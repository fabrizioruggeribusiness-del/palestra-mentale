-- ─────────────────────────────────────────────
-- Player One — Obiettivi del giorno nel cloud (po_daily_goals)
-- Prima erano solo in localStorage del telefono: fragili, non nei backup.
-- Esegui UNA volta nel SQL Editor di Supabase.
-- ─────────────────────────────────────────────

create table if not exists po_daily_goals (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  day        date not null,
  text       text not null,
  done       boolean not null default false,
  position   int  not null default 0,
  created_at timestamptz not null default now()
);

alter table po_daily_goals enable row level security;

drop policy if exists "own_daily_goals" on po_daily_goals;
create policy "own_daily_goals" on po_daily_goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
