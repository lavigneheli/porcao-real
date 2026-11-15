-- Porção Real: esquema do banco (Supabase / PostgreSQL)
-- Projeto independente e fictício, sem vínculo com o iFood.
create extension if not exists pgcrypto;

create table if not exists pratos (
  id text primary key,
  nome text not null,
  descricao text,
  preco numeric(8,2),
  largura_cm numeric(5,1) not null,
  altura_cm numeric(5,1) not null,
  peso_g int,
  serve_label text,
  ativo boolean default true
);

create table if not exists avaliacoes (
  id uuid primary key default gen_random_uuid(),
  prato_id text not null references pratos(id),
  comeu_bem boolean not null,   -- arrastou direita = true
  serviu boolean not null,
  dividir boolean not null,
  comentario text,
  simulado boolean not null default false,  -- true = dado fictício
  criado_em timestamptz not null default now()
);
create index if not exists avaliacoes_prato_data on avaliacoes (prato_id, criado_em);

create table if not exists sugestoes (
  id uuid primary key default gen_random_uuid(),
  prato_id text not null references pratos(id),
  semana date not null,
  pct_comeu_bem numeric(5,1), pct_serviu numeric(5,1), pct_dividir numeric(5,1),
  total_avaliacoes int,
  resumo_ia text,
  sugestao_ia text,
  status text not null default 'pendente' check (status in ('pendente','aprovada','recusada')),
  criado_em timestamptz not null default now()
);

-- Segurança (RLS): o app público só lê pratos e insere avaliações.
-- A automação usa a service role key (nunca no front-end).
alter table pratos enable row level security;
alter table avaliacoes enable row level security;
alter table sugestoes enable row level security;
create policy "ler pratos" on pratos for select using (true);
create policy "inserir avaliacao" on avaliacoes for insert with check (true);

-- Resumo semanal por prato (usado pela automação)
create or replace view resumo_semana as
select prato_id,
  count(*) total,
  round(100.0*avg(comeu_bem::int),1) pct_comeu_bem,
  round(100.0*avg(serviu::int),1) pct_serviu,
  round(100.0*avg(dividir::int),1) pct_dividir
from avaliacoes
where criado_em >= now() - interval '7 days'
group by prato_id;
