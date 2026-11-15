#!/usr/bin/env bash
# Hook SessionEnd do Claude Code (nível de usuário, ~/.claude/settings.json), instalado pelo instalar.sh.
# Quando uma sessão termina dentro de um projeto (qualquer repositório git fora do cérebro), grava em
# raw/ do cérebro o que mudou: pedido inicial, arquivos tocados, commits feitos na sessão, alterações
# pendentes e o último resumo do Claude. O /compilar da noite leva isso para wiki/projetos/<slug>.md.
# Entrada (stdin): JSON do hook {session_id, transcript_path, cwd, reason}.
set -u
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
ENV_FILE=/etc/cerebro-painel.env
CEREBRO="${CEREBRO_DIR:-$(grep -E '^CEREBRO_DIR=' "$ENV_FILE" 2>/dev/null | cut -d= -f2-)}"
[ -n "$CEREBRO" ] || CEREBRO=/root/cerebro
[ -d "$CEREBRO" ] || exit 0

entrada=$(cat 2>/dev/null || true)
cwd=$(printf '%s' "$entrada" | node -e 'let t="";process.stdin.on("data",c=>t+=c).on("end",()=>{try{console.log(JSON.parse(t).cwd||"")}catch{console.log("")}})')
transcript=$(printf '%s' "$entrada" | node -e 'let t="";process.stdin.on("data",c=>t+=c).on("end",()=>{try{console.log(JSON.parse(t).transcript_path||"")}catch{console.log("")}})')
[ -n "$cwd" ] || cwd="$PWD"
case "$cwd" in "$CEREBRO"|"$CEREBRO"/*) exit 0 ;; esac   # sessões no próprio cérebro já têm hooks próprios
raiz=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0
slug=$(basename "$raiz" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
[ -n "$slug" ] || exit 0

# resumo do transcript (JSONL): primeiro pedido, nº de turnos, arquivos editados, último texto do assistente, início
resumo=$(node -e '
const fs=require("fs");const p=process.argv[1];let linhas=[];
try{linhas=fs.readFileSync(p,"utf8").split("\n").filter(Boolean).map(l=>{try{return JSON.parse(l)}catch{return null}}).filter(Boolean)}catch{}
let primeiro="",ultimo="",inicio="",turnos=0;const arquivos=new Set();
const texto=m=>{const c=m&&m.content;if(typeof c==="string")return c;if(Array.isArray(c))return c.filter(x=>x.type==="text").map(x=>x.text).join("\n");return ""};
for(const e of linhas){
  if(!inicio&&e.timestamp)inicio=e.timestamp;
  if(e.type==="user"&&e.message){const t=texto(e.message).trim();if(t&&!primeiro&&!t.startsWith("<"))primeiro=t;turnos++;}
  if(e.type==="assistant"&&e.message){const t=texto(e.message).trim();if(t)ultimo=t;
    const c=e.message.content;if(Array.isArray(c))for(const b of c)if(b.type==="tool_use"&&b.input&&(b.input.file_path||b.input.notebook_path))arquivos.add(b.input.file_path||b.input.notebook_path);}
}
console.log(JSON.stringify({primeiro:primeiro.slice(0,400),ultimo:ultimo.slice(0,1500),inicio,turnos,arquivos:[...arquivos].slice(0,40)}));' "$transcript" 2>/dev/null || echo '{}')
campo() { printf '%s' "$resumo" | node -e 'let t="";process.stdin.on("data",c=>t+=c).on("end",()=>{const j=JSON.parse(t||"{}");const v=j[process.argv[1]];console.log(Array.isArray(v)?v.join("\n"):(v??""))})' "$1"; }
turnos=$(campo turnos); [ "${turnos:-0}" -ge 1 ] 2>/dev/null || exit 0
inicio=$(campo inicio); [ -n "$inicio" ] || inicio=$(date -Is -d '-2 hours')
commits=$(git -C "$raiz" log --since="$inicio" --format='- %h %s (%ad)' --date=format:'%H:%M' 2>/dev/null | head -n 30)
pendente=$(git -C "$raiz" status --porcelain 2>/dev/null | head -n 40)
ramo=$(git -C "$raiz" rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -n "$commits$pendente$(campo arquivos)" ] || [ "$turnos" -ge 3 ] || exit 0   # sessão sem nada de útil

mkdir -p "$CEREBRO/raw"
arq="$CEREBRO/raw/$(date +%Y-%m-%d-%H%M)-sessao-$slug.md"
n=1; while [ -e "$arq" ]; do arq="$CEREBRO/raw/$(date +%Y-%m-%d-%H%M)-sessao-$slug-$((++n)).md"; done
{
  echo "---"
  echo "tipo: sessao"
  echo "criado: $(date +%Y-%m-%dT%H:%M)"
  echo "fonte: claude-code"
  echo "projeto: $slug"
  echo "---"
  echo
  echo "# Sessão de trabalho em $slug"
  echo
  echo "Pasta: \`$raiz\` · branch: $ramo · turnos: $turnos"
  echo
  p=$(campo primeiro); [ -n "$p" ] && { echo "## Pedido inicial"; echo; echo "$p"; echo; }
  [ -n "$commits" ] && { echo "## Commits feitos na sessão"; echo; echo "$commits"; echo; }
  a=$(campo arquivos); [ -n "$a" ] && { echo "## Arquivos editados"; echo; printf '%s\n' "$a" | sed 's/^/- /'; echo; }
  [ -n "$pendente" ] && { echo "## Alterações ainda não commitadas"; echo; echo '```'; echo "$pendente"; echo '```'; echo; }
  u=$(campo ultimo); [ -n "$u" ] && { echo "## Último resumo do Claude"; echo; echo "$u"; echo; }
  echo "Relacionado: [[${slug}]]"
} > "$arq"
dia="$CEREBRO/diario/$(date +%F).md"; mkdir -p "$CEREBRO/diario"
[ -f "$dia" ] || printf '# %s\n\n' "$(date +%F)" > "$dia"
echo "- $(date +%H:%M) Sessão em [[${slug}]]: $turnos turnos$( [ -n "$commits" ] && echo ", $(printf '%s\n' "$commits" | grep -c .) commit(s)") → $(basename "$arq" .md)" >> "$dia"
exit 0
