#!/usr/bin/env bash
# Motor trocável: carrega .claude/motor.env e define rodar_motor. Usado por rodar-agente.sh e avaliar-agente.sh.
# shellcheck disable=SC2034
MOTOR=claude; MODELO_PADRAO=sonnet; MODELO_ARBITRO=haiku; ORCAMENTO_DIA_USD=5
OLLAMA_URL=http://127.0.0.1:11434; OLLAMA_MODELO=qwen2.5:14b
ISOLAMENTO=auto   # auto | sim | nao — isola a rodada com systemd-run (sistema só leitura; escrita só onde o agente pode)
[ -f "$CEREBRO/.claude/motor.env" ] && . "$CEREBRO/.claude/motor.env"
export OLLAMA_URL OLLAMA_MODELO
: "${LOG:=/dev/null}"; : "${EXEC:=/dev/null}"; : "${DIR:=.}"
declare -a PODE 2>/dev/null || true
declare -a ESCREVE_EM 2>/dev/null || true   # caminhos extras com escrita (autonomia reversivel)
ISOLADO_REAL=0   # vira 1 quando a última chamada rodou isolada

# isolamento_disponivel → 0 se dá para usar systemd-run nesta máquina
isolamento_disponivel() {
  [ "$ISOLAMENTO" = nao ] && return 1
  command -v systemd-run >/dev/null 2>&1 || return 1
  local st; st=$(systemctl is-system-running 2>/dev/null || true)
  case "$st" in running|degraded|maintenance|starting) return 0 ;; *) return 1 ;; esac
}

# isolar <rw1,rw2,...> -- comando...   : roda o comando com o sistema de arquivos só leitura, exceto os caminhos dados
isolar() {
  local rw="$1"; shift; [ "$1" = "--" ] && shift
  local props=(-p ProtectSystem=strict -p PrivateTmp=yes -p NoNewPrivileges=yes -p ProtectKernelTunables=yes -p ProtectControlGroups=yes -p RestrictSUIDSGID=yes -p ProtectClock=yes)
  local p; IFS=',' read -ra lista <<< "$rw"
  for p in "${lista[@]}" "$HOME/.claude" "$HOME/.claude.json" "$HOME/.cache" "$HOME/.npm" "/tmp"; do
    [ -n "$p" ] || continue
    [ -e "$p" ] || { case "$p" in */execucoes|*.md) ;; *) continue ;; esac; }
    props+=(-p "ReadWritePaths=$p")
  done
  for p in /etc/cerebro-agentes /etc/cerebro-painel.env "$HOME/.ssh" "$HOME/.gnupg" "$CEREBRO/.claude/motor.env"; do
    [ -e "$p" ] && props+=(-p "InaccessiblePaths=$p")
  done
  local envs=(--setenv=HOME="$HOME" --setenv=PATH="$PATH" --setenv=LANG="${LANG:-C.UTF-8}")
  for v in CEREBRO_AGENTE CEREBRO_RUN CEREBRO_EXEC CLAUDE_PROJECT_DIR OLLAMA_URL OLLAMA_MODELO SIMULADO_VEREDITO SIMULADO_DESPACHOS; do
    [ -n "${!v:-}" ] && envs+=(--setenv="$v=${!v}")
  done
  systemd-run --quiet --pipe --wait --collect --same-dir "${props[@]}" "${envs[@]}" -- "$@"
}

# caminhos onde a rodada atual pode escrever: execução, pendências e raw do agente + escreve_em do agente + o cérebro inteiro se reversível
rw_da_rodada() {
  local lista="$CEREBRO/$EXEC,$CEREBRO/$DIR/pendencias.md,$CEREBRO/raw,$CEREBRO/.git,$CEREBRO/.claude/agentes"
  [ "${AUTONOMIA:-leitura}" = reversivel ] && lista="$CEREBRO,$lista"
  local e; for e in "${ESCREVE_EM[@]}"; do [ -n "$e" ] && lista="$lista,$e"; done
  echo "$lista"
}

# executar_motor <saida> <cmd...> : roda isolado quando possível; stdin = prompt
executar_motor() {
  local saida="$1"; shift
  ISOLADO_REAL=0
  if isolamento_disponivel; then
    if isolar "$(rw_da_rodada)" -- "$@" > "$saida" 2>>"$LOG"; then ISOLADO_REAL=1; return 0; fi
    local rc=$?
    # systemd-run devolve 1 e saída vazia quando nem conseguiu criar a unidade; aí decide pelo modo
    if [ ! -s "$saida" ] && [ "$ISOLAMENTO" = sim ]; then
      echo "isolamento obrigatório (ISOLAMENTO=sim) e systemd-run falhou (rc=$rc)" >> "$LOG"; return 1
    fi
    if [ -s "$saida" ]; then ISOLADO_REAL=1; return 0; fi
    echo "AVISO: systemd-run falhou (rc=$rc); rodando SEM isolamento" >> "$LOG"
  elif [ "$ISOLAMENTO" = sim ]; then
    echo "isolamento obrigatório (ISOLAMENTO=sim) mas systemd-run não está disponível" >> "$LOG"; return 1
  fi
  "$@" > "$saida" 2>>"$LOG" || true
}

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
      printf '%s' "$prompt" | executar_motor "$saida" claude "${args[@]}" || { echo '{"result":"","custo":0,"turnos":0,"duracao":0,"erro":true,"subtipo":"isolamento indisponível (ISOLAMENTO=sim)"}'; rm -f "$saida"; return 1; }
      ;;
    ollama)
      printf '%s' "$prompt" | executar_motor "$saida" node "$CEREBRO/.claude/scripts/motor-ollama.js" --modelo "$modelo" --ferramentas "$tools" --pode-executar "$(printf '%s\n' "${PODE[@]}")" --max-turnos "$turnos" --escrever "$EXEC,raw/,$DIR/pendencias.md$([ "${AUTONOMIA:-leitura}" = reversivel ] && for e in "${ESCREVE_EM[@]}"; do [ -n "$e" ] && printf ',%s' "$e"; done)" --raiz "$CEREBRO" --extra "$extra" || { echo '{"result":"","custo":0,"turnos":0,"duracao":0,"erro":true,"subtipo":"isolamento indisponível (ISOLAMENTO=sim)"}'; rm -f "$saida"; return 1; }
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
