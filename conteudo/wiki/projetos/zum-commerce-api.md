---
tipo: projeto
status: ativo
atualizado: 2026-11-15
fontes: [[2026-11-15-0100-github-zum-commerce-api]]
---

# Zum Commerce API

API em C# do **Zum Commerce**: guarda as credenciais Shopify de cada loja (criptografadas com AES-256), valida o login do Firebase e faz tudo que exige a Admin API da Shopify (produtos, estoque, fotos, clientes, publicação nos canais de venda).

## Stack
ASP.NET Core Web API, .NET 10 · Firestore · Firebase Auth (JWT) · Shopify Admin API (GraphQL) · Google Cloud Run. Camadas: Core.Domain, Core.Application, Core.Infrastructure (+CrossCutting, IoC), Core.Web; testes xUnit. Configuração em `docs/CONFIGURACAO.md`; endpoints em `backend/docs/ENDPOINTS.md`.

## Estado
6 commits (23/10–08/11/2026), em par com o front.

## Relacionados
[[zum-commerce]] (front) · [[zum-shop]] · [[zum-web-studio]]
