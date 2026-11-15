#!/usr/bin/env bash
# Importa o conteúdo gerado em conteudo/ (carga inicial a partir do GitHub) para o cérebro.
#   raw/            → copiado se o arquivo ainda não existir (raw é append-only)
#   wiki/projetos/  → página nova: copiada inteira
#                     página existente só com o esqueleto do ligar-projetos (comentário "escreva aqui"): recebe o corpo
#                     página existente já escrita por você: não é tocada (o conteúdo fica no raw/ e o /compilar incorpora)
# Uso: bash importar-conteudo.sh            (lê CEREBRO_DIR de /etc/cerebro-painel.env; padrão /opt/cerebro)
set -u
KIT="$(cd "$(dirname "$0")" && pwd)"
CEREBRO="${CEREBRO_DIR:-$(grep -E '^CEREBRO_DIR=' /etc/cerebro-painel.env 2>/dev/null | cut -d= -f2-)}"
[ -n "$CEREBRO" ] || CEREBRO=/opt/cerebro
[ -d "$CEREBRO/wiki" ] || { echo "cérebro não encontrado em $CEREBRO (defina CEREBRO_DIR)"; exit 1; }
cd "$CEREBRO" || exit 1
mkdir -p raw wiki/projetos
novos_raw=0; novas=0; preenchidas=0; mantidas=0

for f in "$KIT"/conteudo/raw/*.md; do
  [ -e "raw/$(basename "$f")" ] && continue
  cp "$f" raw/ && novos_raw=$((novos_raw+1))
done

for f in "$KIT"/conteudo/wiki/projetos/*.md; do
  nome=$(basename "$f"); alvo="wiki/projetos/$nome"
  if [ ! -f "$alvo" ]; then
    cp "$f" "$alvo"; novas=$((novas+1)); echo "nova: $alvo"
  elif grep -q '<!-- escreva aqui o que o projeto' "$alvo"; then
    # corpo = tudo depois do título H1 da página gerada
    corpo=$(awk 'f{print} /^# /{f=1}' "$f")
    fontes_novas=$(grep -m1 '^fontes:' "$f" | sed 's/^fontes: *//')
    node -e '
      const fs=require("fs");const [alvo,corpo,fontes]=process.argv.slice(1);
      let t=fs.readFileSync(alvo,"utf8");
      t=t.replace(/<!-- escreva aqui o que o projeto[^\n]*-->\n?/, corpo.trim()+"\n");
      t=t.replace(/^fontes: (.*)$/m,(m,a)=>"fontes: "+a+(a.trim()?", ":"")+fontes);
      fs.writeFileSync(alvo,t);' "$alvo" "$corpo" "$fontes_novas"
    preenchidas=$((preenchidas+1)); echo "preenchida: $alvo"
  else
    mantidas=$((mantidas+1))
  fi
done

# índice
if [ -f _indice.md ]; then
  grep -q '^## Projetos' _indice.md || printf '\n## Projetos\n' >> _indice.md
  for f in "$KIT"/conteudo/wiki/projetos/*.md; do
    s=$(basename "$f" .md); t=$(grep -m1 '^# ' "$f" | sed 's/^# //')
    grep -q "\[\[$s\]\]" _indice.md || sed -i "/^## Projetos/a - [[$s]] — $t" _indice.md
  done
fi

if git rev-parse --verify HEAD >/dev/null 2>&1 && [ -n "$(git status --porcelain)" ]; then
  git add -A && git -c user.name=cerebro -c user.email=cerebro@localhost commit -q -m "carga inicial do GitHub: $novas páginas novas, $preenchidas preenchidas, $novos_raw raw" || true
fi
echo "raw novos: $novos_raw · páginas novas: $novas · preenchidas: $preenchidas · mantidas (já escritas por você): $mantidas"
echo "Para incorporar o raw/ nas páginas que você já tinha: cd $CEREBRO && claude → /compilar"
