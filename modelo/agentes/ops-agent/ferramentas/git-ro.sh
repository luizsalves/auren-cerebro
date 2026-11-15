#!/usr/bin/env bash
# git só leitura num projeto da VPS. Uso: git-ro.sh <pasta> status|log|diff|branch|remote
set -u
pasta="${1:-}"; acao="${2:-status}"
case "$pasta" in /opt/projetos/*|/opt/saas/*) ;; *) echo "pasta fora de /opt/projetos ou /opt/saas"; exit 1 ;; esac
[ -d "$pasta/.git" ] || { echo "sem .git em $pasta"; exit 1; }
case "$acao" in
  status) git -C "$pasta" status --short --branch ;;
  log)    git -C "$pasta" log --oneline --decorate -n "${3:-15}" ;;
  diff)   git -C "$pasta" diff --stat; echo; git -C "$pasta" diff | head -n 200 ;;
  branch) git -C "$pasta" branch -vv ;;
  remote) git -C "$pasta" remote -v | sed -E 's#//[^@/]+@#//#' ;;
  *) echo "ação desconhecida: $acao (status|log|diff|branch|remote)"; exit 1 ;;
esac
