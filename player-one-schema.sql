-- ─────────────────────────────────────────────
-- Player One — nuove tabelle (Corpo, Disciplina, Ruota)
-- Stesso progetto Supabase di Palestra Mentale.
-- Esegui UNA volta nel SQL Editor. Le tabelle pm_* restano invariate.
-- ─────────────────────────────────────────────

-- ── Modulo Corpo: esercizi della scheda ──
create table if not exists po_exercises (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  day_name   text not null,            -- es. 'Femorali + Tricipiti'
  day_order  int  not null default 0,
  name       text not null,
  scheme     text,                     -- es. '3x6/8'
  position   int  not null default 0,
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

-- ── Modulo Corpo: log allenamenti ──
create table if not exists po_workout_logs (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users on delete cascade,
  exercise_id uuid not null references po_exercises on delete cascade,
  day         date not null,
  sets        jsonb not null,          -- [{"w":90,"r":7}, ...]
  note        text,
  created_at  timestamptz not null default now()
);

-- ── Modulo Disciplina: abitudini ──
create table if not exists po_habits (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  name       text not null,
  emoji      text,
  tier       text not null default 'standard',  -- boss | standard | secondaria | dispersione
  points     int  not null default 1,
  position   int  not null default 0,
  active     boolean not null default true,
  created_at timestamptz not null default now()
);

-- ── Modulo Disciplina: check giornalieri ──
create table if not exists po_habit_days (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  habit_id   uuid not null references po_habits on delete cascade,
  day        date not null,
  done       boolean not null,
  created_at timestamptz not null default now(),
  unique (user_id, habit_id, day)
);

-- ── Ruota della Vita: autovalutazioni mensili (aree non attive) ──
create table if not exists po_wheel (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  area       text not null,            -- salute | crescita | tempo | famiglia | finanze | business | mindset | spirito
  month      text not null,            -- 'YYYY-MM'
  score      int  not null check (score between 0 and 10),
  note       text,
  created_at timestamptz not null default now(),
  unique (user_id, area, month)
);

-- ── Tracciamento peso corporeo ──
create table if not exists po_weight (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users on delete cascade,
  day        date not null,
  kg         numeric(5,2) not null check (kg > 30 and kg < 300),
  created_at timestamptz not null default now(),
  unique (user_id, day)
);

-- ── Sicurezza: ogni utente vede e modifica SOLO i propri dati ──
alter table po_exercises    enable row level security;
alter table po_weight       enable row level security;
alter table po_workout_logs enable row level security;
alter table po_habits       enable row level security;
alter table po_habit_days   enable row level security;
alter table po_wheel        enable row level security;

drop policy if exists "own_exercises" on po_exercises;
create policy "own_exercises" on po_exercises
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_workout_logs" on po_workout_logs;
create policy "own_workout_logs" on po_workout_logs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_habits" on po_habits;
create policy "own_habits" on po_habits
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_habit_days" on po_habit_days;
create policy "own_habit_days" on po_habit_days
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_wheel" on po_wheel;
create policy "own_wheel" on po_wheel
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_weight" on po_weight;
create policy "own_weight" on po_weight
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
