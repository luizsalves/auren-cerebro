---
tipo: levantamento
criado: 2026-11-15T01:00
fonte: github (luizsalves/zum-shop), leitura automática do repositório
---

# Levantamento do repositório zum-shop

Repositório: https://github.com/luizsalves/zum-shop
Lido em 2026-11-15 (clone raso, até 80 commits). Seções: histórico git, árvore, manifestos, README, contagem de arquivos.

```
## git
2026-11-08 Acompanha a branch principal dos dois projetos
2026-11-08 Organiza Zum Shop com submódulos dos projetos
primeiro: 2026-11-08 · total(≤80): 2 · branch: main
## arvore
.
README.md
zum-commerce
zum-commerce-api
## manifestos
## README (README.md)
# Zum Shop
Repositório privado que reúne os dois projetos do Zum Commerce como submódulos Git, preservando os repositórios e seus históricos independentes.
## Estrutura
| Pasta | Repositório | Branch acompanhada |
|---|---|---|
| `zum-commerce/` | [luizsalves/zum-commerce](https://github.com/luizsalves/zum-commerce) | `main` |
| `zum-commerce-api/` | [luizsalves/zum-commerce-api](https://github.com/luizsalves/zum-commerce-api) | `main` |
Na máquina de desenvolvimento, a raiz é `C:\Projetos\zum-shop`. Na VPS, a raiz permanece em `/opt/saas/loja-virtual/zum-shop`.
## Atualização
A sincronização acompanha cada repositório filho de forma independente na branch indicada. Os gitlinks deste agregador registram os commits de referência; novos commits dos filhos devem ser obtidos nos próprios repositórios pela rotina de sincronização, mesmo quando o commit do agregador não mudar.
Para uma cópia nova com os commits de referência:
```sh
git clone --recurse-submodules https://github.com/luizsalves/zum-shop.git
```
Os diretórios `chaves/` e `secrets/`, os arquivos de ambiente, as chaves privadas e os backups ficam fora do Git. A sincronização do código preserva essas configurações e não altera nem reinicia serviços da VPS.
Consulte o README e o AGENTS.md de cada projeto para instalação, compilação e testes.
## docs
## contagem
      1 md       1 gitmodules       1 gitignore 

```
