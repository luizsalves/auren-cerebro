# ferramentas/ — código deste agente

Só você edita (o agente não pode reescrever as próprias ferramentas). Regras:

- Um comando por ação, chamado pelo agente via `pode_executar` do `agente.md`.
  Ex.: `node agentes/<nome>/ferramentas/consultar.js --cliente X` → imprime JSON ou texto curto.
- Credenciais nunca aqui: leia de `/etc/cerebro-agentes/<nome>.env` (só root lê). Nada de `.env` nesta pasta.
- `node_modules/` fica fora do git (já está no .gitignore). `npm install` roda aqui dentro.
- Saída = dado para o agente analisar; erros em texto claro (código de saída ≠ 0).
- Produto com deploy e vida própria não mora aqui: fica em `/opt/...` e o `codigo:` aponta para lá.
