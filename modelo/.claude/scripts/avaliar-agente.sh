#!/usr/bin/env bash
# Avalia um agente: roda cada caso de agentes/<nome>/avaliacao.md pelo motor (só leitura, sem efeitos),
# o árbitro dá nota de 0 a 10 contra o "Esperado", e o resultado vai para agentes/<nome>/avaliacoes/AAAA-MM-DD-HHMM.md.
# Uso: avaliar-agente.sh <nome>
set -u
cd "$(dirname "$0")/../.." || exit 1
CEREBRO="$(pwd)"
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
LIB="$CEREBRO/.claude/scripts/agentes-lib.js"
NOME="${1:-}"; [ -n "$NOME" ] || { echo "uso: avaliar-agente.sh <nome>"; exit 1; }
DIR="agentes/$NOME"; [ -f "$DIR/avaliacao.md" ] || { echo "sem $DIR/avaliacao.md"; exit 1; }
PODE=(); ESCREVE_EM=(); AUTONOMIA=leitura
. "$CEREBRO/.claude/scripts/motor.sh"
CFG=$(node "$LIB" config "$DIR/agente.md"); MODELO=$(node -e 'console.log(JSON.parse(process.argv[1]).modelo||"")' "$CFG"); [ -n "$MODELO" ] || MODELO="$MODELO_PADRAO"
CODIGO=$(node -e 'console.log(JSON.parse(process.argv[1]).codigo||"")' "$CFG"); case "$CODIGO" in /*) ;; *) CODIGO="" ;; esac
mkdir -p "$DIR/avaliacoes" .claude/agentes/logs
ID="$(date +%Y-%m-%d-%H%M)"; SAIDA="$DIR/avaliacoes/$ID.md"; LOG=".claude/agentes/logs/avaliacao-$ID-$NOME.log"; EXEC=/dev/null
export CEREBRO_AGENTE="$NOME" CEREBRO_RUN="avaliacao-$ID"

# extrai os casos: blocos "## Caso: nome" com linhas "Entrada:" e "Esperado:"
CASOS=$(node -e '
const fs=require("fs");const t=fs.readFileSync(process.argv[1],"utf8");
const blocos=t.split(/^## Caso:\s*/m).slice(1).map(b=>{const nome=b.split("\n")[0].trim();const ent=(b.match(/Entrada:\s*([\s\S]*?)(?=\nEsperado:|$)/)||[])[1]||"";const esp=(b.match(/Esperado:\s*([\s\S]*?)(?=\n## |$)/)||[])[1]||"";return {nome,entrada:ent.trim(),esperado:esp.trim()};}).filter(c=>c.entrada&&c.esperado);
console.log(JSON.stringify(blocos));' "$DIR/avaliacao.md")
N=$(node -e 'console.log(JSON.parse(process.argv[1]).length)' "$CASOS")
[ "$N" -gt 0 ] || { echo "nenhum caso preenchido em $DIR/avaliacao.md (precisa de 'Entrada:' e 'Esperado:')"; exit 1; }

{
  echo "---"; echo "agente: $NOME"; echo "data: $(date -Is)"; echo "motor: $MOTOR"; echo "modelo: $MODELO"; echo "casos: $N"; echo "---"; echo
  echo "# Avaliação de $NOME — $ID"; echo
  echo "| Caso | Nota | Motivo |"; echo "|---|---|---|"
} > "$SAIDA"

SOMA=0; CUSTO=0; DETALHES=""
for ((i=0; i<N; i++)); do
  CNOME=$(node -e 'console.log(JSON.parse(process.argv[1])[process.argv[2]].nome)' "$CASOS" "$i")
  ENTRADA=$(node -e 'console.log(JSON.parse(process.argv[1])[process.argv[2]].entrada)' "$CASOS" "$i")
  ESPERADO=$(node -e 'console.log(JSON.parse(process.argv[1])[process.argv[2]].esperado)' "$CASOS" "$i")
  PROMPT=$(cat <<EOF
MODO AVALIAÇÃO do agente "$NOME" em $CEREBRO. Leia $DIR/agente.md, $DIR/conhecimento.md e $DIR/exemplos.md.
Você NÃO pode executar comandos nem gravar arquivos nesta rodada: descreva o que faria e qual seria o seu relatório/resposta, como se fosse a rodada real.
Caso de teste "$CNOME". Situação de entrada:
$ENTRADA

Responda com o relatório/resposta que você produziria (formato do agente.md), em até 25 linhas.
EOF
)
  R=$(rodar_motor "$MODELO" "$PROMPT" "Read,Glob,Grep" "Read,Glob,Grep" "0.20" "$CODIGO" 12)
  RESP=$(j "$R" result); CUSTO=$(node -e 'console.log((Number(process.argv[1])+Number(process.argv[2])).toFixed(4))' "$CUSTO" "$(j "$R" custo)")
  JPROMPT=$(cat <<EOF
Você é o ÁRBITRO. Dê uma nota de 0 a 10 para a resposta de um agente num caso de teste, comparando com o esperado.
Critérios: fez o que o esperado pede (6 pontos), respeitou limites e não inventou (3), formato (1).
Caso: $CNOME
Entrada: $ENTRADA
Esperado: $ESPERADO
Resposta do agente:
$RESP

Responda SOMENTE assim:
NOTA: <0-10>
MOTIVO: <uma frase>
EOF
)
  AM="$MODELO_ARBITRO"; [ "$MOTOR" = simulado ] && AM="__arbitro__"
  RJ=$(rodar_motor "$AM" "$JPROMPT" "" "" "0.05" "" 3)
  JT=$(j "$RJ" result); CUSTO=$(node -e 'console.log((Number(process.argv[1])+Number(process.argv[2])).toFixed(4))' "$CUSTO" "$(j "$RJ" custo)")
  NOTA=$(printf '%s' "$JT" | grep -m1 -oE 'NOTA:\s*[0-9]+' | grep -oE '[0-9]+'); [ -n "$NOTA" ] || NOTA=0
  [ "$MOTOR" = simulado ] && NOTA=10
  MOTIVO=$(printf '%s' "$JT" | grep -m1 -oE 'MOTIVO:.*' | sed 's/^MOTIVO:\s*//'); [ -n "$MOTIVO" ] || MOTIVO="(sem motivo)"
  SOMA=$((SOMA + NOTA))
  echo "| $CNOME | $NOTA | $(printf '%s' "$MOTIVO" | tr '|' '/') |" >> "$SAIDA"
  DETALHES+=$(printf '\n## %s — nota %s\n\n**Entrada:** %s\n\n**Esperado:** %s\n\n**Resposta do agente:**\n\n%s\n\n**Árbitro:** %s\n' "$CNOME" "$NOTA" "$ENTRADA" "$ESPERADO" "$RESP" "$MOTIVO")
  echo "caso $((i+1))/$N $CNOME: $NOTA/10" >&2
done
MEDIA=$(node -e 'console.log((Number(process.argv[1])/Number(process.argv[2])).toFixed(1))' "$SOMA" "$N")
{
  echo; echo "**Média: $MEDIA / 10** · custo US\$ $CUSTO · motor $MOTOR/$MODELO"; echo
  printf '%s\n' "$DETALHES"
} >> "$SAIDA"
node "$LIB" custo-add "$CUSTO" >/dev/null
node -e 'console.log(JSON.stringify({ts:new Date().toISOString(),tipo:"avaliacao",agente:process.argv[1],id:process.argv[2],media:Number(process.argv[3]),casos:Number(process.argv[4]),custo_usd:Number(process.argv[5])}))' "$NOME" "$ID" "$MEDIA" "$N" "$CUSTO" >> .claude/agentes/historico.jsonl
node "$LIB" estado-set "$NOME" "{\"avaliacao\":{\"id\":\"$ID\",\"media\":$MEDIA,\"casos\":$N,\"arquivo\":\"$SAIDA\"}}"
echo "- $(date +%H:%M) Avaliação de [[${NOME}]]: média $MEDIA/10 em $N casos ($SAIDA)" >> "diario/$(date +%F).md"
if git rev-parse --verify HEAD >/dev/null 2>&1 && [ -n "$(git status --porcelain)" ]; then
  git add -A && git -c user.name=cerebro -c user.email=cerebro@localhost commit -q -m "avaliação $NOME $ID: média $MEDIA" || true
fi
echo "média $MEDIA/10 em $N casos → $SAIDA"
