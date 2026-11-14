#!/usr/bin/env bash
# Motor trocável: carrega .claude/motor.env e define rodar_motor. Usado por rodar-agente.sh e avaliar-agente.sh.
# shellcheck disable=SC2034
MOTOR=claude; MODELO_PADRAO=sonnet; MODELO_ARBITRO=haiku; ORCAMENTO_DIA_USD=5
OLLAMA_URL=http://127.0.0.1:11434; OLLAMA_MODELO=qwen2.5:14b
[ -f "$CEREBRO/.claude/motor.env" ] && . "$CEREBRO/.claude/motor.env"
export OLLAMA_URL OLLAMA_MODELO
: "${LOG:=/dev/null}"; : "${EXEC:=/dev/null}"; : "${DIR:=.}"
declare -a PODE 2>/dev/null || true

# rodar_motor <modelo> <prompt> <tools-csv> <allowed-csv> <orcamento> <pasta-extra> <max-turnos> → imprime JSON {result,custo,turnos,duracao,erro}
rodar_motor() {
  local modelo="$1" prompt="$2" tools="$3" allowed="$4" orc="$5" extra="$6" turnos="$7"
  local saida; saida=$(mktemp)
  case "$MOTOR" in
    claude)
      if ! command -v claude >/dev/null 2>&1; then echo '{"result":"","custo":0,"turnos":0,"duracao":0,"erro":true,"subtipo":"claude não instalado"}'; return 1; fi
      local args=(-p --model "$modelo" --output-format json --permission-mode acceptEdits --max-budget-usd "$orc")
      [ -n "$tools" ] && args+=(--tools "$tools")
      [ -n "$allowed" ] && args+=(--allowedTools "$allowed")
      [ -n "$extra" ] && [ -d "$extra" ] && args+=(--add-dir "$extra")
      printf '%s' "$prompt" | claude "${args[@]}" > "$saida" 2>>"$LOG" || true
      ;;
    ollama)
      printf '%s' "$prompt" | node "$CEREBRO/.claude/scripts/motor-ollama.js" --modelo "$modelo" --ferramentas "$tools" --pode-executar "$(printf '%s\n' "${PODE[@]}")" --max-turnos "$turnos" --escrever "$EXEC,raw/,$DIR/pendencias.md" --raiz "$CEREBRO" --extra "$extra" > "$saida" 2>>"$LOG" || true
      ;;
    simulado)
      # para testar a instalação sem gastar nada: SIMULADO_VEREDITO=aprovado|reprovado|revisar, SIMULADO_DESPACHOS="DESPACHAR: x | tarefa"
      if [ "$modelo" = "__arbitro__" ]; then
        node -e 'console.log(JSON.stringify({type:"result",result:"VEREDITO: "+(process.env.SIMULADO_VEREDITO||"aprovado")+"\nMOTIVOS:\n- simulação\nPENDENCIAS:\n- nenhuma",total_cost_usd:0,num_turns:1,duration_ms:5}))' > "$saida"
      else
        printf '## Resumo\nRodada simulada (MOTOR=simulado): nada foi consultado.\n\n## O que verifiquei\n- nada\n\n## Encontrado\n- nada\n\n## Preparado para aprovação\n- nada\n\n## Fatos novos gravados em raw/\n- nenhum\n\n## Propostas para pendencias.md\n- nenhuma\n\n## Precisa de decisão\n- nada\n' >> "$EXEC"
        node -e 'console.log(JSON.stringify({type:"result",result:"Rodada simulada. Relatório gravado.\n"+(process.env.SIMULADO_DESPACHOS||""),total_cost_usd:0,num_turns:1,duration_ms:5}))' > "$saida"
      fi
      ;;
    *) echo "{\"result\":\"\",\"custo\":0,\"turnos\":0,\"duracao\":0,\"erro\":true,\"subtipo\":\"MOTOR desconhecido: $MOTOR\"}"; return 1 ;;
  esac
  node "$LIB" resultado "$saida"
  rm -f "$saida"
}
j() { node -e 'const r=JSON.parse(process.argv[1]);const v=r[process.argv[2]];console.log(typeof v==="object"?JSON.stringify(v):(v??""))' "$1" "$2"; }

j() { node -e 'const r=JSON.parse(process.argv[1]);const v=r[process.argv[2]];console.log(typeof v==="object"?JSON.stringify(v):(v??""))' "$1" "$2"; }
