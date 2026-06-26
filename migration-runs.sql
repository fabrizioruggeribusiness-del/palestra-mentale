-- ─────────────────────────────────────────────
-- Player One — Corpo: corsa (facoltativa)
-- Log delle uscite di corsa. Facoltativa: niente penalità se non corri.
-- Esegui UNA volta. Idempotente.
-- ─────────────────────────────────────────────

create table if not exists po_runs (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users on delete cascade,
  day          date not null,
  distance_km  numeric(5,2) not null check (distance_km > 0 and distance_km < 1000),
  duration_sec int  not null check (duration_sec > 0),
  type         text,                       -- lento | medio | intervalli | lungo
  hr           int  check (hr is null or (hr > 30 and hr < 250)),
  note         text,
  created_at   timestamptz not null default now()
);

alter table po_runs enable row level security;

drop policy if exists "own_runs" on po_runs;
create policy "own_runs" on po_runs
  for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create index if not exists idx_po_runs_user_day on po_runs(user_id, day);
