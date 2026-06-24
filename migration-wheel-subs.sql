-- ─────────────────────────────────────────────
-- Player One — Ruota della Vita: sub-dimensioni + scala 0–10
-- Esegui UNA volta nel SQL Editor di Supabase. po_wheel è vuota: nessun rischio dati.
-- ─────────────────────────────────────────────

-- sub-punteggi per le aree composite (Business, Crescita, Mindset)
alter table po_wheel add column if not exists subs jsonb;

-- la scala ora ammette lo 0 (es. Proattività 0, Meditazione 0)
alter table po_wheel drop constraint if exists po_wheel_score_check;
alter table po_wheel add constraint po_wheel_score_check check (score between 0 and 10);
