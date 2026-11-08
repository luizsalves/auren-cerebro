#!/usr/bin/env bash
# Liga os projetos da VPS ao cérebro.
#
# Para cada pasta em PASTAS (padrão: /opt/projetos e /opt/saas), menos as
# listadas em EXCLUIR (padrão: secrets):
#   - registra o inventário em raw/ (só quando algo mudou);
#   - cria ou atualiza wiki/projetos/<slug>.md com um bloco "Na VPS"
#     (caminho, stack, git, última atividade, resumo do README);
#   - mantém o hub wiki/notas/projetos-vps.md e o _indice.md;
#   - libera as pastas para o Claude Code ler (permissions.additionalDirectories);
#   - mantém a tabela "Projetos na VPS" no CLAUDE.md.
#
# Uso: bash .claude/scripts/ligar-projetos.sh
#      PASTAS="/opt/projetos /opt/saas /srv/x" EXCLUIR="secrets tmp" bash .claude/scripts/ligar-projetos.sh
set -u
cd "$(dirname "$0")/../.." || exit 1
CEREBRO="$(pwd)"
PASTAS="${PASTAS:-/opt/projetos /opt/saas}"
EXCLUIR="${EXCLUIR:-secrets}"
HOJE=$(date +%Y-%m-%d)
AGORA=$(date +%H%M)
MARCA_INI='<!-- vps:inicio -->'
MARCA_FIM='<!-- vps:fim -->'

mkdir -p wiki/projetos wiki/notas raw .claude

slug() {
  printf '%s' "$1" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null \
    | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}
excluido() { for e in $EXCLUIR; do [ "$1" = "$e" ] && return 0; done; return 1; }

stack_de() {
  local d="$1" s=()
  if [ -f "$d/package.json" ]; then
    local deps; deps=$(tr -d '\n ' < "$d/package.json")
    case "$deps" in *'"next"'*) s+=("Next.js");; *'"react"'*) s+=("React");; *'"vue"'*) s+=("Vue");; *) s+=("Node.js");; esac
    case "$deps" in *'"typescript"'*) s+=("TypeScript");; esac
    case "$deps" in *'"tailwindcss"'*) s+=("Tailwind");; esac
    case "$deps" in *'"express"'*) s+=("Express");; *'"fastify"'*) s+=("Fastify");; *'"@nestjs/core"'*) s+=("NestJS");; esac
    case "$deps" in *'"prisma"'*|*'"@prisma/client"'*) s+=("Prisma");; esac
  fi
  { [ -f "$d/requirements.txt" ] || [ -f "$d/pyproject.toml" ]; } && s+=("Python")
  ls "$d"/*.csproj "$d"/*.sln "$d"/*/*.csproj >/dev/null 2>&1 && s+=("C#/.NET")
  [ -f "$d/composer.json" ] && s+=("PHP")
  [ -f "$d/go.mod" ] && s+=("Go")
  { [ -f "$d/Dockerfile" ] || ls "$d"/docker-compose*.y*ml >/dev/null 2>&1; } && s+=("Docker")
  [ -f "$d/index.html" ] && [ ${#s[@]} -eq 0 ] && s+=("HTML estático")
  [ ${#s[@]} -eq 0 ] && s+=("não identificada")
  local IFS=,; printf '%s' "${s[*]}" | sed 's/,/, /g'
}

resumo_readme() {
  local f
  for f in "$1"/README.md "$1"/readme.md "$1"/README.MD "$1"/README; do [ -f "$f" ] && break; f=""; done
  [ -n "$f" ] || return 0
  # primeiras linhas de texto (sem títulos, imagens, badges), até 6
  grep -vE '^\s*(#|!\[|\[!\[|<|```|---|\s*$)' "$f" | head -n 6 | sed 's/^/> /'
}

git_info() {
  local d="$1"
  [ -d "$d/.git" ] || return 0
  local remoto ramo ult
  remoto=$(git -C "$d" remote get-url origin 2>/dev/null | sed -E 's#//[^@/]+@#//#')   # tira usuário:token
  ramo=$(git -C "$d" rev-parse --abbrev-ref HEAD 2>/dev/null)
  ult=$(git -C "$d" log -1 --format='%ad — %s' --date=short 2>/dev/null)
  [ -n "$remoto" ] && echo "- Repositório: $remoto"
  [ -n "$ramo" ] && echo "- Branch: $ramo"
  [ -n "$ult" ] && echo "- Último commit: $ult"
}

ultima_alteracao() {
  find "$1" -type f -not -path '*/.git/*' -not -path '*/node_modules/*' -printf '%TY-%Tm-%Td\n' 2>/dev/null | sort | tail -n 1
}

# ---------- 1. Inventário ----------
declare -a NOMES CAMINHOS SLUGS
for base in $PASTAS; do
  [ -d "$base" ] || continue
  for d in "$base"/*/; do
    d="${d%/}"; nome="$(basename "$d")"
    excluido "$nome" && continue
    [ -d "$d" ] || continue
    NOMES+=("$nome"); CAMINHOS+=("$d"); SLUGS+=("$(slug "$nome")")
  done
done
[ ${#NOMES[@]} -gt 0 ] || { echo "nenhum projeto encontrado em: $PASTAS"; exit 0; }

INVENTARIO=$(mktemp)
for i in "${!NOMES[@]}"; do
  d="${CAMINHOS[$i]}"
  {
    echo "## ${NOMES[$i]}"
    echo "- Caminho: $d"
    echo "- Stack: $(stack_de "$d")"
    git_info "$d"
    ua=$(ultima_alteracao "$d"); [ -n "$ua" ] && echo "- Última alteração: $ua"
    r=$(resumo_readme "$d"); [ -n "$r" ] && { echo "- README:"; echo "$r"; }
    echo
  } >> "$INVENTARIO"
done

# ---------- 2. raw/ (só quando mudou) ----------
hash_novo=$(sha256sum "$INVENTARIO" | cut -d' ' -f1)
hash_ant=$(cat .claude/ultimo-inventario-vps 2>/dev/null || true)
RAW_REL=$(grep -l '^fonte: ligar-projetos.sh' raw/*-projetos-vps.md 2>/dev/null | sort | tail -n 1 | sed 's#\.md$##')
if [ "$hash_novo" != "$hash_ant" ] || [ -z "$RAW_REL" ]; then
  RAW_REL="raw/$HOJE-$AGORA-projetos-vps"
  n=1; while [ -e "$RAW_REL.md" ]; do RAW_REL="raw/$HOJE-$AGORA-projetos-vps-$((++n))"; done
  {
    echo "---"
    echo "tipo: captura"
    echo "criado: $HOJE $(date +%H:%M)"
    echo "fonte: ligar-projetos.sh"
    echo "---"
    echo
    echo "# Projetos na VPS ($(hostname))"
    echo
    echo "Inventário automático das pastas: $PASTAS (menos: $EXCLUIR)."
    echo
    cat "$INVENTARIO"
  } > "$RAW_REL.md"
  echo "$hash_novo" > .claude/ultimo-inventario-vps
  echo "raw: $RAW_REL.md"
fi
RAW_NOME=$(basename "$RAW_REL")
rm -f "$INVENTARIO"

# ---------- 3. wiki/projetos/<slug>.md ----------
for i in "${!NOMES[@]}"; do
  nome="${NOMES[$i]}"; d="${CAMINHOS[$i]}"; s="${SLUGS[$i]}"
  arq="wiki/projetos/$s.md"
  bloco=$(mktemp)
  {
    echo "$MARCA_INI"
    echo "## Na VPS"
    echo "<!-- bloco mantido por ligar-projetos.sh; edite fora das marcas -->"
    echo "- Caminho: \`$d\`"
    echo "- Stack: $(stack_de "$d")"
    git_info "$d"
    ua=$(ultima_alteracao "$d"); [ -n "$ua" ] && echo "- Última alteração nos arquivos: $ua"
    r=$(resumo_readme "$d"); [ -n "$r" ] && { echo; echo "README:"; echo; echo "$r"; }
    echo
    echo "Faz parte de [[projetos-vps]]."
    echo "$MARCA_FIM"
  } > "$bloco"

  if [ -f "$arq" ]; then
    if grep -qF "$MARCA_INI" "$arq"; then
      awk -v ini="$MARCA_INI" -v fim="$MARCA_FIM" -v b="$bloco" '
        index($0, ini) { while ((getline l < b) > 0) print l; pulando=1; next }
        index($0, fim) { pulando=0; next }
        !pulando { print }' "$arq" > "$arq.tmp" && mv "$arq.tmp" "$arq"
    else
      { echo; cat "$bloco"; } >> "$arq"
    fi
    sed -i -E "s/^atualizado: .*/atualizado: $HOJE/" "$arq"
    grep -q "\[\[$RAW_NOME\]\]" "$arq" || sed -i -E "0,/^fontes: (.*)$/s//fontes: \1, [[$RAW_NOME]]/" "$arq"
    grep -q '^fontes:' "$arq" || sed -i "0,/^---$/!{0,/^---$/s//fontes: [[$RAW_NOME]]\n---/}" "$arq"
  else
    {
      echo "---"
      echo "tipo: projeto"
      echo "status: ativo"
      echo "atualizado: $HOJE"
      echo "fontes: [[$RAW_NOME]]"
      echo "---"
      echo
      echo "# $nome"
      echo
      echo "<!-- escreva aqui o que o projeto é, para quem, decisões; o /compilar completa com o raw/ -->"
      echo
      cat "$bloco"
    } > "$arq"
    echo "nova página: $arq"
  fi
  rm -f "$bloco"
done

# ---------- 4. hub wiki/notas/projetos-vps.md ----------
{
  echo "---"
  echo "tipo: nota"
  echo "status: ativo"
  echo "atualizado: $HOJE"
  echo "fontes: [[$RAW_NOME]]"
  echo "---"
  echo
  echo "# Projetos na VPS"
  echo
  echo "Pastas: \`$(echo $PASTAS | sed 's/ /`, `/g')\` (menos: $EXCLUIR). Atualizado por \`ligar-projetos.sh\`."
  echo
  echo "| Projeto | Pasta | Stack |"
  echo "|---|---|---|"
  for i in "${!NOMES[@]}"; do
    echo "| [[${SLUGS[$i]}]] | \`${CAMINHOS[$i]}\` | $(stack_de "${CAMINHOS[$i]}") |"
  done
} > wiki/notas/projetos-vps.md

# ---------- 5. _indice.md ----------
if [ -f _indice.md ]; then
  grep -q '^## Projetos' _indice.md || printf '\n## Projetos\n' >> _indice.md
  grep -q '^## Notas' _indice.md || printf '\n## Notas\n' >> _indice.md
  for i in "${!NOMES[@]}"; do
    s="${SLUGS[$i]}"
    grep -q "\[\[$s\]\]" _indice.md || sed -i "/^## Projetos/a - [[$s]] — ${NOMES[$i]} (pasta \`${CAMINHOS[$i]}\`)" _indice.md
  done
  grep -q '\[\[projetos-vps\]\]' _indice.md || sed -i '/^## Notas/a - [[projetos-vps]] — hub dos projetos que vivem na VPS' _indice.md
fi

# ---------- 6. permissões do Claude Code ----------
if command -v node >/dev/null 2>&1; then
  printf '%s\n' "${CAMINHOS[@]}" | node -e '
    const fs = require("fs");
    const arq = ".claude/settings.json";
    let s = {}; try { s = JSON.parse(fs.readFileSync(arq, "utf8")); } catch {}
    const dirs = fs.readFileSync(0, "utf8").split("\n").filter(Boolean);
    s.permissions = s.permissions || {};
    const atuais = new Set(s.permissions.additionalDirectories || []);
    for (const d of dirs) atuais.add(d);
    s.permissions.additionalDirectories = [...atuais].sort();
    fs.writeFileSync(arq, JSON.stringify(s, null, 2) + "\n");
  '
fi

# ---------- 7. CLAUDE.md ----------
if [ -f CLAUDE.md ]; then
  bloco=$(mktemp)
  {
    echo "$MARCA_INI"
    echo "## Projetos na VPS"
    echo
    echo "Código dos meus projetos (fora desta pasta; você pode ler, mas só altera se eu pedir)."
    echo "Pergunta sobre um projeto → abra a página dele na wiki e, se precisar, o código na pasta."
    echo "Hub: [[projetos-vps]]. Lista mantida por \`.claude/scripts/ligar-projetos.sh\`."
    echo
    echo "| Projeto | Pasta | Página |"
    echo "|---|---|---|"
    for i in "${!NOMES[@]}"; do
      echo "| ${NOMES[$i]} | \`${CAMINHOS[$i]}\` | \`wiki/projetos/${SLUGS[$i]}.md\` |"
    done
    echo "$MARCA_FIM"
  } > "$bloco"
  if grep -qF "$MARCA_INI" CLAUDE.md; then
    awk -v ini="$MARCA_INI" -v fim="$MARCA_FIM" -v b="$bloco" '
      index($0, ini) { while ((getline l < b) > 0) print l; pulando=1; next }
      index($0, fim) { pulando=0; next }
      !pulando { print }' CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
  else
    { echo; cat "$bloco"; } >> CLAUDE.md
  fi
  rm -f "$bloco"
fi

# ---------- 8. scripts de deploy (.claude/deploy/<slug>.sh) ----------
# Gerados uma vez a partir da stack detectada; depois são seus (não são sobrescritos).
mkdir -p .claude/deploy/logs
for i in "${!NOMES[@]}"; do
  d="${CAMINHOS[$i]}"; s="${SLUGS[$i]}"; arq=".claude/deploy/$s.sh"
  [ -f "$arq" ] && continue
  {
    echo "#!/usr/bin/env bash"
    echo "# Deploy de ${NOMES[$i]} — rodado pelo painel (botão Deploy) dentro da pasta abaixo."
    echo "# PASTA=$d"
    echo "# Edite à vontade. Gerado por ligar-projetos.sh em $HOJE a partir da stack: $(stack_de "$d")"
    echo "set -euo pipefail"
    echo 'cd "$(sed -n "s/^# PASTA=//p" "$0")"'
    echo 'echo "▸ git pull"'
    if [ -d "$d/.git" ]; then
      echo 'git pull --ff-only'
    else
      echo 'echo "pasta sem .git — nada para puxar"; exit 1'
    fi
    if [ -f "$d/deploy.sh" ]; then
      echo 'echo "▸ deploy.sh do projeto"; bash ./deploy.sh'
    fi
    if ls "$d"/docker-compose*.y*ml >/dev/null 2>&1 || [ -f "$d/compose.yaml" ]; then
      echo 'echo "▸ docker compose"; docker compose up -d --build --remove-orphans'
    fi
    if [ -f "$d/package.json" ]; then
      echo 'echo "▸ npm install"; if [ -f package-lock.json ]; then npm ci --no-audit --no-fund; else npm install --no-audit --no-fund; fi'
      grep -q '"build"' "$d/package.json" && echo 'echo "▸ npm run build"; npm run build'
      if command -v pm2 >/dev/null 2>&1 && pm2 describe "${NOMES[$i]}" >/dev/null 2>&1; then
        echo "echo \"▸ pm2 restart\"; pm2 restart \"${NOMES[$i]}\""
      fi
    fi
    if [ -f "$d/requirements.txt" ]; then
      echo 'echo "▸ pip"; if [ -x .venv/bin/pip ]; then .venv/bin/pip install -q -r requirements.txt; else pip install -q -r requirements.txt; fi'
    fi
    svc=$(systemctl list-units --type=service --all --no-legend 2>/dev/null | awk '{print $1}' | grep -i -m1 "^$s\.service$\|^${NOMES[$i]}\.service$" || true)
    [ -n "$svc" ] && echo "echo \"▸ systemctl restart $svc\"; systemctl restart $svc"
    echo 'echo "✓ deploy concluído"'
  } > "$arq"
  chmod +x "$arq"
  echo "deploy: $arq"
done

# ---------- 9. commit ----------
if git rev-parse --verify HEAD >/dev/null 2>&1 && [ -n "$(git status --porcelain)" ]; then
  git add -A && git commit -q -m "ligar-projetos: ${#NOMES[@]} projetos da VPS ($HOJE)" && echo "commit feito"
fi
echo "ligados: ${#NOMES[@]} projetos → wiki/projetos/, hub wiki/notas/projetos-vps.md, CLAUDE.md, settings.json"
