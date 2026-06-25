-- ─────────────────────────────────────────────
-- Player One — tracciamento peso corporeo
-- Esegui UNA volta nel SQL Editor di Supabase.
-- ─────────────────────────────────────────────

create table if not exists po_weight (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  day        date not null,
  kg         numeric(5,2) not null check (kg > 30 and kg < 300),
  created_at timestamptz not null default now(),
  unique (user_id, day)
);

alter table po_weight enable row level security;
drop policy if exists "own_weight" on po_weight;
create policy "own_weight" on po_weight
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
