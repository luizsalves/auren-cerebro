#!/usr/bin/env bash
# Saúde do cérebro: painel, última compilação, raw/ pendente, disco, crons, agentes com pendência. Só leitura. Sai em JSON.
# Uso: bash agentes/devops-agent/ferramentas/saude-cerebro.sh
set -u
cd "$(dirname "$0")/../../.." || exit 1
CEREBRO="$(pwd)"
json() { node -e 'console.log(JSON.stringify(process.argv[1]))' "$1"; }

painel=$(systemctl is-active cerebro-painel 2>/dev/null || echo "desconhecido")
porta=$(grep -E '^PORT=' /etc/cerebro-painel.env 2>/dev/null | cut -d= -f2); [ -n "$porta" ] || porta=3333
http=$(curl -s -o /dev/null -m 5 -w '%{http_code}' "http://127.0.0.1:$porta/login" 2>/dev/null || echo "000")

ult_compilacao=$(grep -E 'compilar' .claude/rotina.log 2>/dev/null | grep -E 'fim|ok|conclu' | tail -n 1 | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}[T ][0-9:]{5,8}' | tail -n 1)
[ -n "$ult_compilacao" ] || ult_compilacao=$(git log -1 --format=%cI --grep=compilar 2>/dev/null)
horas_compilacao=""; [ -n "$ult_compilacao" ] && horas_compilacao=$(node -e 'const d=Date.parse(process.argv[1]);console.log(isNaN(d)?"":Math.round((Date.now()-d)/36e5))' "$ult_compilacao")

# raw/ sem citação na wiki = pendente de compilar
raw_total=$(ls raw/*.md 2>/dev/null | wc -l | tr -d ' ')
raw_pend=0
for f in raw/*.md; do [ -f "$f" ] || continue; st=$(basename "$f" .md); grep -rqF "[[${st}]]" wiki diario 2>/dev/null || raw_pend=$((raw_pend+1)); done

disco=$(df -P "$CEREBRO" | awk 'NR==2{gsub("%","",$5);print $5}')
disco_livre=$(df -h -P "$CEREBRO" | awk 'NR==2{print $4}')
cron_ok=false; [ -f /etc/cron.d/cerebro ] && cron_ok=true
cron_agentes=false; [ -f /etc/cron.d/cerebro-agentes ] && cron_agentes=true
claude_ok=false; command -v claude >/dev/null 2>&1 && claude_ok=true
ult_commit=$(git log -1 --format='%cI %s' 2>/dev/null)
motor=$(grep -E '^MOTOR=' .claude/motor.env 2>/dev/null | cut -d= -f2); [ -n "$motor" ] || motor=claude
custo_hoje=$(node .claude/scripts/agentes-lib.js custo-hoje 2>/dev/null || echo 0)

agentes_pend=$(node -e '
const fs=require("fs");const out=[];
for(const n of (fs.existsSync("agentes")?fs.readdirSync("agentes"):[])){if(n.startsWith("_"))continue;const p="agentes/"+n+"/pendencias.md";if(!fs.existsSync(p))continue;
const k=(fs.readFileSync(p,"utf8").match(/^- \[ \] \S/gm)||[]).length;if(k)out.push({agente:n,pendencias:k});}
console.log(JSON.stringify(out));' 2>/dev/null || echo '[]')

cat <<EOF
{
  "gerado": "$(date -Is)",
  "painel": { "servico": "$painel", "http_login": "$http" },
  "compilacao": { "ultima": $(json "$ult_compilacao"), "horas_atras": $(json "$horas_compilacao") },
  "raw": { "total": $raw_total, "pendentes_de_compilar": $raw_pend },
  "disco": { "uso_pct": ${disco:-0}, "livre": $(json "$disco_livre") },
  "cron": { "cerebro": $cron_ok, "agentes": $cron_agentes },
  "claude_instalado": $claude_ok,
  "motor": $(json "$motor"),
  "custo_agentes_hoje_usd": ${custo_hoje:-0},
  "ultimo_commit_cerebro": $(json "$ult_commit"),
  "agentes_com_pendencia": $agentes_pend
}
EOF
