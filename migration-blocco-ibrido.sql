-- ─────────────────────────────────────────────
-- Player One — Blocco ibrido (settembre 2026)
-- Scheda nuova: pesi + condizionamento + mobilità + benchmark,
-- con versione piena e versione minima ("piano B").
-- Esegui UNA volta. Idempotente: si può rilanciare senza danni.
-- I dati esistenti non vengono toccati: la scheda vecchia viene
-- disattivata dall'app (active = false), lo storico resta.
-- ─────────────────────────────────────────────

-- ── Esercizi: metadati della nuova scheda ──
alter table po_exercises add column if not exists plan        text;                 -- blocco di appartenenza
alter table po_exercises add column if not exists variant     text not null default 'piena';  -- piena | minima
alter table po_exercises add column if not exists sets_target int;                  -- serie previste
alter table po_exercises add column if not exists reps_target text;                 -- '8-10', '30-45 sec', ...
alter table po_exercises add column if not exists rest_sec    int;                  -- recupero previsto
alter table po_exercises add column if not exists rpe         numeric(3,1);
alter table po_exercises add column if not exists rir         int;
alter table po_exercises add column if not exists big_lift    boolean not null default false;
alter table po_exercises add column if not exists is_core     boolean not null default false;
alter table po_exercises add column if not exists muscle      text;                 -- gruppo per il calcolo volume
alter table po_exercises add column if not exists note        text;

create index if not exists po_exercises_plan_idx on po_exercises (user_id, plan, variant);

-- ── Configurazione del blocco (una riga per utente) ──
create table if not exists po_block (
  user_id    uuid primary key references auth.users on delete cascade,
  start_date date not null,                        -- lunedì della settimana 1
  mode       text not null default 'piena',        -- piena | minima
  mode_since date,                                 -- da quando siamo in questa modalità
  birth_date date,                                 -- parto: attiva la minima automatica per 4 settimane
  updated_at timestamptz not null default now()
);

-- ── Condizionamento non-corsa (vogatore, sacco, MMA tecnica, corda) ──
-- La corsa continua a vivere in po_runs: ha campi suoi (passo, FC).
create table if not exists po_conditioning (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  day        date not null,
  kind       text not null,                        -- vogatore_lungo | vogatore_corto | mma_sacco | mma_tecnica | corda
  detail     text,                                 -- prescrizione effettivamente svolta
  week       int,                                  -- settimana del blocco
  note       text,
  created_at timestamptz not null default now()
);
create index if not exists po_conditioning_day_idx on po_conditioning (user_id, day);

-- ── Mobilità: checklist giornaliera, separata dai pesi ──
create table if not exists po_mobility (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  day        date not null,
  minutes    int,
  created_at timestamptz not null default now(),
  unique (user_id, day)
);

-- ── Benchmark: settimana 0 e settimana 8 ──
create table if not exists po_benchmarks (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  test_id    text not null,                        -- trazioni | panca | squat | military | corsa | mobilita | foto
  week       int  not null,                        -- 0 | 8
  value      text not null,
  note       text,
  day        date not null,
  created_at timestamptz not null default now(),
  unique (user_id, test_id, week)
);

-- ── Sicurezza: stessa regola delle altre tabelle ──
alter table po_block        enable row level security;
alter table po_conditioning enable row level security;
alter table po_mobility     enable row level security;
alter table po_benchmarks   enable row level security;

drop policy if exists "own_block" on po_block;
create policy "own_block" on po_block
  for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "own_conditioning" on po_conditioning;
create policy "own_conditioning" on po_conditioning
  for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "own_mobility" on po_mobility;
create policy "own_mobility" on po_mobility
  for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

drop policy if exists "own_benchmarks" on po_benchmarks;
create policy "own_benchmarks" on po_benchmarks
  for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
