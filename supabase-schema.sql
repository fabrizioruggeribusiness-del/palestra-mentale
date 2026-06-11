-- ─────────────────────────────────────────────
-- Schema Supabase per Palestra Mentale
-- Stesso progetto di Fabrizio RPG: esegui nel SQL Editor (una volta sola)
-- ─────────────────────────────────────────────

create table if not exists pm_books (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users on delete cascade,
  title       text not null,
  author      text,
  status      text not null default 'attivo', -- attivo | conquistato | abbandonato
  created_at  timestamptz not null default now(),
  finished_at timestamptz
);

create table if not exists pm_checkins (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references auth.users on delete cascade,
  book_id         uuid not null references pm_books on delete cascade,
  day             date not null,
  summary         text not null,
  application     text,
  score           int not null,
  coach_comment   text,
  recall_question text,
  recall_answer   text,
  recall_result   text,
  points          int not null default 0,
  created_at      timestamptz not null default now(),
  unique (user_id, day) -- un allenamento al giorno
);

-- Sicurezza: ogni utente vede e modifica SOLO i propri dati
alter table pm_books    enable row level security;
alter table pm_checkins enable row level security;

drop policy if exists "own_books" on pm_books;
create policy "own_books" on pm_books
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_checkins" on pm_checkins;
create policy "own_checkins" on pm_checkins
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
