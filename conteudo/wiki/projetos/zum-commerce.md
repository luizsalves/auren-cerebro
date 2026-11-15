---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-zum-commerce]]
---

# Zum Commerce (front)

Front-end do **Zum Commerce**, a plataforma SaaS da [[zum-web-studio]] para lojas que vendem pela Shopify: a Zum administra todas as lojas num painel; cada lojista tem sua loja isolada (produtos, clientes, taxas, acessos); cada loja vende por um site sob medida (ex.: [[elika-tiaras]]) ou pela vitrine padrão; o lojista cadastra produtos no SaaS com simulador de taxas; o cliente final compra com cadastro (Google, Facebook ou e-mail); pagamento e checkout são sempre da Shopify. Modelo: implantação + mensalidade por loja.

## Stack
React 19, TypeScript, Vite, Tailwind 4, Firebase (Auth, Firestore, Hosting), Shopify Storefront API. `firebase.json` redireciona `/api/**` para a API no Cloud Run (`southamerica-east1`). Fotos de produto vão pela API direto para a Shopify (Storage não é usado).

## Estado
6 commits (23/10–08/11/2026): estrutura inicial, escolha dos canais de venda no painel, envio de fotos para a Shopify, conciliação com ajustes feitos na VPS. Escopo completo em `ESCOPO_DO_PROJETO.md`.

## Relacionados
[[zum-commerce-api]] (back) · [[zum-shop]] (agregador) · [[loja-virtual]] (pasta na VPS) · [[zum-web-studio]] · [[elika-tiaras]]
