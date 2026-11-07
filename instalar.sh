#!/usr/bin/env bash
# Instala o segundo cérebro + painel numa VPS Ubuntu/Debian.
#
# Uso:
#   sudo bash instalar.sh
# Variáveis opcionais:
#   CEREBRO_DIR=/root/cerebro   pasta do cérebro
#   PORTA=3333                  porta do painel
#   PAINEL_SENHA=...            senha do painel (se vazio, pergunta)
#   DOMINIO=cerebro.seusite.com.br  com domínio → HTTPS automático via Caddy
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
CEREBRO_DIR="${CEREBRO_DIR:-/root/cerebro}"
PORTA="${PORTA:-3333}"
DOMINIO="${DOMINIO:-}"
APP_DIR=/opt/cerebro-painel
ENV_FILE=/etc/cerebro-painel.env

verde() { printf '\033[32m%s\033[0m\n' "$*"; }
amarelo() { printf '\033[33m%s\033[0m\n' "$*"; }
passo() { printf '\n\033[35m▸ %s\033[0m\n' "$*"; }

[ "$(id -u)" -eq 0 ] || { echo "Rode como root: sudo bash instalar.sh"; exit 1; }

# ---------- 1. Dependências ----------
passo "Dependências (git, Node.js 18+)"
export DEBIAN_FRONTEND=noninteractive
command -v git >/dev/null || { apt-get update -qq && apt-get install -y -qq git; }
command -v flock >/dev/null || apt-get install -y -qq util-linux
precisa_node=1
if command -v node >/dev/null; then
  [ "$(node -p 'process.versions.node.split(".")[0]')" -ge 18 ] && precisa_node=0
fi
if [ "$precisa_node" = 1 ]; then
  apt-get install -y -qq curl ca-certificates >/dev/null
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  apt-get install -y -qq nodejs
fi
verde "node $(node -v) · git $(git --version | awk '{print $3}')"

# ---------- 2. Pasta do cérebro ----------
passo "Cérebro em $CEREBRO_DIR"
mkdir -p "$CEREBRO_DIR"
# copia o modelo sem sobrescrever nada que já exista
cp -rn "$KIT/modelo/." "$CEREBRO_DIR/" 2>/dev/null || true
# arquivos do sistema (regras, skills, hooks, scripts) são atualizados sempre
mkdir -p "$CEREBRO_DIR/.claude"
cp -r "$KIT/modelo/.claude/rules" "$KIT/modelo/.claude/skills" "$KIT/modelo/.claude/hooks" "$KIT/modelo/.claude/scripts" "$CEREBRO_DIR/.claude/"
[ -f "$CEREBRO_DIR/.claude/settings.json" ] || cp "$KIT/modelo/.claude/settings.json" "$CEREBRO_DIR/.claude/"
chmod +x "$CEREBRO_DIR"/.claude/hooks/* "$CEREBRO_DIR"/.claude/scripts/*
[ -e "$CEREBRO_DIR/AGENTS.md" ] || ln -s CLAUDE.md "$CEREBRO_DIR/AGENTS.md"
hoje=$(date +%Y-%m-%d)
sed -i "s/atualizado: AAAA-MM-DD/atualizado: $hoje/" "$CEREBRO_DIR/agora.md" "$CEREBRO_DIR/wiki/decisoes.md" 2>/dev/null || true

cd "$CEREBRO_DIR"
if [ ! -d .git ]; then
  git init -q
  git config user.name >/dev/null || git config user.name "cerebro"
  git config user.email >/dev/null || git config user.email "cerebro@localhost"
fi
git add -A
git commit -q -m "instalação do cérebro $(date '+%Y-%m-%d %H:%M')" || true
verde "estrutura pronta"

# ---------- 3. Painel ----------
passo "Painel em $APP_DIR"
mkdir -p "$APP_DIR"
cp -r "$KIT/painel/." "$APP_DIR/"

if [ -f "$ENV_FILE" ] && grep -q '^PAINEL_SENHA=.' "$ENV_FILE" && [ -z "${PAINEL_SENHA:-}" ]; then
  PAINEL_SENHA=$(grep '^PAINEL_SENHA=' "$ENV_FILE" | cut -d= -f2-)
  amarelo "mantendo a senha já configurada"
fi
if [ -z "${PAINEL_SENHA:-}" ]; then
  while true; do
    read -rsp "Escolha a senha do painel (mín. 8 caracteres): " PAINEL_SENHA; echo
    [ "${#PAINEL_SENHA}" -ge 8 ] && break
    echo "Muito curta."
  done
fi
SEGREDO=$(grep '^PAINEL_SEGREDO=' "$ENV_FILE" 2>/dev/null | cut -d= -f2- || true)
[ -n "$SEGREDO" ] || SEGREDO=$(head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n')
HOST=0.0.0.0; [ -n "$DOMINIO" ] && HOST=127.0.0.1

umask 077
cat > "$ENV_FILE" <<EOF
CEREBRO_DIR=$CEREBRO_DIR
PORT=$PORTA
HOST=$HOST
PAINEL_SENHA=$PAINEL_SENHA
PAINEL_SEGREDO=$SEGREDO
PROXIMA_COMPILACAO=23:30
EOF
umask 022

cat > /etc/systemd/system/cerebro-painel.service <<EOF
[Unit]
Description=Painel do Cérebro
After=network.target

[Service]
EnvironmentFile=$ENV_FILE
ExecStart=$(command -v node) $APP_DIR/server.js
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now cerebro-painel >/dev/null 2>&1
systemctl restart cerebro-painel
sleep 1
systemctl is-active --quiet cerebro-painel && verde "painel rodando" || { amarelo "painel não subiu:"; journalctl -u cerebro-painel -n 20 --no-pager; }

# ---------- 4. HTTPS com domínio (opcional) ----------
if [ -n "$DOMINIO" ]; then
  passo "HTTPS com Caddy em $DOMINIO"
  if ! command -v caddy >/dev/null; then
    apt-get install -y -qq debian-keyring debian-archive-keyring apt-transport-https curl gnupg >/dev/null
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' > /etc/apt/sources.list.d/caddy-stable.list
    apt-get update -qq && apt-get install -y -qq caddy
  fi
  cat > /etc/caddy/Caddyfile <<EOF
$DOMINIO {
  encode gzip
  reverse_proxy 127.0.0.1:$PORTA {
    flush_interval -1
  }
}
EOF
  systemctl restart caddy
  verde "Caddy configurado"
fi

# ---------- 5. Firewall ----------
if command -v ufw >/dev/null && ufw status | grep -q "Status: active"; then
  passo "Firewall (ufw)"
  if [ -n "$DOMINIO" ]; then ufw allow 80/tcp >/dev/null; ufw allow 443/tcp >/dev/null; else ufw allow "$PORTA"/tcp >/dev/null; fi
  verde "portas liberadas"
fi

# ---------- 6. Rotinas (cron) ----------
passo "Rotinas agendadas"
CLAUDE_BIN=$(command -v claude || echo /root/.local/bin/claude)
cat > /etc/cron.d/cerebro <<EOF
# Segundo cérebro — horário do servidor
SHELL=/bin/bash
PATH=$(dirname "$CLAUDE_BIN"):/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOME=/root
30 23 * * *  root  bash $CEREBRO_DIR/.claude/scripts/rotina.sh compilar
0 20 * * 0   root  bash $CEREBRO_DIR/.claude/scripts/rotina.sh revisao
0 19 * * 0   root  bash $CEREBRO_DIR/.claude/scripts/rotina.sh lint
EOF
chmod 644 /etc/cron.d/cerebro
verde "compilar 23:30 todo dia · lint e revisão domingo 19:00/20:00"
[ -x "$CLAUDE_BIN" ] || amarelo "Claude Code não encontrado. Instale com: curl -fsSL https://claude.ai/install.sh | bash  (e faça login rodando: claude)"
TZ_ATUAL=$(timedatectl show -p Timezone --value 2>/dev/null || echo "?")
[ "$TZ_ATUAL" = "America/Sao_Paulo" ] || amarelo "Fuso do servidor: $TZ_ATUAL. Para horário de Brasília: timedatectl set-timezone America/Sao_Paulo"

# ---------- Pronto ----------
IP=$(curl -fsS -4 --max-time 4 https://ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
echo
verde "════════════════════════════════════════════"
verde " Cérebro instalado"
verde "════════════════════════════════════════════"
if [ -n "$DOMINIO" ]; then echo " Painel:  https://$DOMINIO"; else echo " Painel:  http://$IP:$PORTA"; fi
echo " Pasta:   $CEREBRO_DIR"
echo " Usar:    cd $CEREBRO_DIR && claude   →  /entrevista para começar"
[ -z "$DOMINIO" ] && amarelo " Sem domínio o painel usa HTTP. Para HTTPS: DOMINIO=seu.dominio sudo bash instalar.sh"
echo
