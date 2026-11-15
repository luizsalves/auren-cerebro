#!/usr/bin/env bash
# Estado de sincronia GitHub × VPS × Windows para cada projeto. Só leitura (git fetch, status, log). Sai em JSON.
# Uso: bash agentes/ops-agent/ferramentas/status-sync.sh   (PASTAS="/opt/projetos /opt/saas" EXCLUIR="secrets")
set -u
cd "$(dirname "$0")/../../.." || exit 1
CEREBRO="$(pwd)"
PASTAS="${PASTAS:-/opt/projetos /opt/saas}"
EXCLUIR="${EXCLUIR:-secrets}"
export GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=10"
ESTADO_DEPLOY="$CEREBRO/.claude/deploy/estado.json"

excluido() { for e in $EXCLUIR; do [ "$1" = "$e" ] && return 0; done; return 1; }
slug() { printf '%s' "$1" | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'; }
json() { node -e 'console.log(JSON.stringify(process.argv[1]))' "$1"; }

itens=""
for base in $PASTAS; do
  [ -d "$base" ] || continue
  for d in "$base"/*/; do
    d="${d%/}"; nome="$(basename "$d")"; excluido "$nome" && continue
    s=$(slug "$nome")
    if [ ! -d "$d/.git" ]; then
      itens="$itens{\"projeto\":$(json "$nome"),\"slug\":$(json "$s"),\"pasta\":$(json "$d"),\"situacao\":\"sem-git\"},"; continue
    fi
    remoto=$(git -C "$d" remote get-url origin 2>/dev/null | sed -E 's#//[^@/]+@#//#')
    ramo=$(git -C "$d" rev-parse --abbrev-ref HEAD 2>/dev/null)
    sujo=$(git -C "$d" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    ult=$(git -C "$d" log -1 --format='%ad %s' --date=short 2>/dev/null)
    atras=0; frente=0; situacao="ok"; erro=""
    if [ -z "$remoto" ]; then
      situacao="sem-remoto"
    else
      if ! saida=$(timeout 40 git -C "$d" fetch -q origin 2>&1); then
        situacao="erro-fetch"; erro=$(printf '%s' "$saida" | tail -n 1 | cut -c1-160)
      else
        up=$(git -C "$d" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo "origin/$ramo")
        if git -C "$d" rev-parse --verify -q "$up" >/dev/null; then
          atras=$(git -C "$d" rev-list --count "HEAD..$up" 2>/dev/null || echo 0)
          frente=$(git -C "$d" rev-list --count "$up..HEAD" 2>/dev/null || echo 0)
          if [ "$atras" -gt 0 ] && [ "$frente" -gt 0 ]; then situacao="divergente"
          elif [ "$atras" -gt 0 ]; then situacao="atrasado"
          elif [ "$frente" -gt 0 ]; then situacao="a-frente"; fi
        else
          situacao="sem-upstream"
        fi
      fi
    fi
    [ "$sujo" -gt 0 ] && [ "$situacao" = ok ] && situacao="sujo"
    novos=""; [ "$atras" -gt 0 ] && novos=$(git -C "$d" log --format='%h %s' "HEAD..$up" 2>/dev/null | head -n 5 | tr '\n' ';')
    # último deploy e estado na máquina Windows (gravados pelo painel)
    dep=$(node -e '
      const fs=require("fs");let e={};try{e=JSON.parse(fs.readFileSync(process.argv[1],"utf8"))}catch{}
      const h=(e.historico||{})[process.argv[2]];const ag=e.agente||{};
      const out={ultimo_deploy:h?{quando:new Date(h.fim||h.inicio).toISOString(),ok:h.ok,windows:h.windows?h.windows.estado:null}:null,
                 windows_online:ag.visto?(Date.now()-ag.visto<90000):false,windows_visto:ag.visto?new Date(ag.visto).toISOString():null};
      console.log(JSON.stringify(out));' "$ESTADO_DEPLOY" "$s" 2>/dev/null || echo '{}')
    itens="$itens{\"projeto\":$(json "$nome"),\"slug\":$(json "$s"),\"pasta\":$(json "$d"),\"remoto\":$(json "$remoto"),\"branch\":$(json "$ramo"),\"situacao\":\"$situacao\",\"atras\":$atras,\"a_frente\":$frente,\"arquivos_alterados\":$sujo,\"ultimo_commit\":$(json "$ult"),\"commits_novos_no_github\":$(json "$novos"),\"erro\":$(json "$erro"),\"deploy\":$dep},"
  done
done
printf '{"gerado":"%s","pastas":"%s","projetos":[%s]}\n' "$(date -Is)" "$PASTAS" "${itens%,}" | node -e 'let t="";process.stdin.on("data",c=>t+=c).on("end",()=>{const j=JSON.parse(t);j.resumo={total:j.projetos.length};for(const p of j.projetos)j.resumo[p.situacao]=(j.resumo[p.situacao]||0)+1;console.log(JSON.stringify(j,null,2))})'
