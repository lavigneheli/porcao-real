# Porção Real

Projeto independente e fictício, inspirado em apps de delivery. Sem vínculo com o iFood.

**Problema:** a foto de um prato não mostra o tamanho real, e a avaliação por estrelas não diz se a porção serviu.

**Solução:**
1. Tocar e segurar a foto do prato mostra o prato em escala, ao lado de um objeto conhecido (celular, mão, moeda).
2. Avaliação por arrastar (sim/não): comeu bem? serviu? dava pra dividir? Comentário opcional.
3. Automação semanal: as respostas viram um resumo com IA e uma sugestão de novo "serve X pessoas", aprovada pelo restaurante.

**Dados:** os pratos, medidas e avaliações de demonstração são FICTÍCIOS (`simulado = true`).

## Estrutura
- `index.html`: protótipo do app (HTML único)
- `schema.sql`: tabelas, segurança (RLS) e view de resumo semanal
- `seed.sql`: 200 avaliações simuladas
- `automacao/`: fluxo semanal (em construção)

## Rodar
1. Crie um projeto no Supabase e rode `schema.sql` e depois `seed.sql` no SQL Editor.
2. Preencha `SUPABASE_URL` e `SUPABASE_KEY` (chave anon) no topo de `index.html`.
3. Publique na Vercel (projeto estático).

## Limitações
- O "ao vivo" é uma animação. No produto real seria um vídeo curto.
- A escala é relativa: pratos grandes não cabem em 1:1 na tela do celular.
- Ainda não validado com usuários reais.
