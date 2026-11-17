# Porção Real

Projeto independente e fictício, inspirado em apps de delivery. Sem vínculo com o iFood.

**Demo:** https://porcao-real.vercel.app/ · **Relatório da loja:** https://porcao-real.vercel.app/relatorio.html

**Problema:** a foto de um prato não mostra o tamanho real, e a avaliação por estrelas não diz se a porção serviu.

**Solução:**
1. **Ver:** tocar e segurar a foto do prato mostra o prato em escala, ao lado de um objeto conhecido (celular, mão, moeda).
2. **Avaliar:** "match do pedido", arrastando sim ou não: comeu bem? serviu? dava pra dividir? Comentário opcional.
3. **Ajustar:** toda semana uma automação transforma as respostas em um resumo, as reclamações mais citadas, uma sugestão de novo "serve X pessoas" e uma estratégia de marketplace. O restaurante recebe por e-mail e aprova. Nada muda no cardápio sem aprovação humana.

**Dados:** os pratos, medidas e avaliações de demonstração são FICTÍCIOS (`simulado = true`).

## Como funciona a automação (Make)

```
HTTP (resumo da semana) > Iterator (um prato por vez) > HTTP (comentários negativos)
> Gemini (resumo, sugestão, problemas, estratégia em JSON) > Parse JSON
> HTTP POST (grava em sugestoes, status pendente) > Text aggregator
> HTTP (e-mail pronto) > Gmail
```

- Agendada para toda segunda-feira, 08:00.
- O banco monta o HTML do e-mail (view `email_semana`), então o Make só busca e envia.
- A IA só usa os dados recebidos, não inventa números e devolve JSON com campos fixos (prompt em `automacao/email/prompt_gemini.txt`).
- A decisão final é do restaurante: a sugestão nasce como `pendente`.

## Estrutura

- `index.html`: protótipo do app (HTML único): cardápio com peek em escala e match do pedido.
- `relatorio.html`: relatório semanal da loja, com dados do Supabase, gráficos animados e filtros.
- `email-assets/`: imagens usadas no e-mail (topo e anéis de progresso).
- `schema.sql`: tabelas, segurança (RLS) e view de resumo semanal.
- `seed.sql`: 200 avaliações simuladas.
- `automacao/email/email_v2.sql`: colunas extras, view `email_semana` e permissões do relatório.
- `automacao/email/build_v5.py`: gera o SQL e o preview do e-mail.
- `automacao/email/prompt_gemini.txt`: prompt do Gemini.

## Segurança

- RLS ativo: o app público só lê `pratos` e `sugestoes` e só insere em `avaliacoes`.
- A chave `service_role` fica apenas no Make, nunca no front-end nem neste repositório.
- Dados fictícios; nenhuma informação pessoal é coletada.

## Rodar

1. Crie um projeto no Supabase e rode `schema.sql`, depois `seed.sql` e depois `automacao/email/email_v2.sql` no SQL Editor.
2. Preencha `SUPABASE_URL` e a chave anon (publishable) em `index.html` e `relatorio.html`.
3. Publique na Vercel (projeto estático).
4. No Make, monte o fluxo acima com a chave `service_role` nos headers `apikey` e `Authorization`.

## Limitações

- O "ao vivo" é uma animação. No produto real seria um vídeo curto.
- A escala é relativa: pratos grandes não cabem em 1:1 na tela do celular.
- O e-mail é feito com HTML compatível com clientes de e-mail, então não tem animação (ela está no relatório web).
- Ainda não validado com usuários reais.

## Autora

Helen Lavigne Almeida Martins, estudante de Medicina e AI Builder.
