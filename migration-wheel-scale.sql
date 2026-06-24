-- ─────────────────────────────────────────────
-- Player One — Ruota della Vita: scala 0–10 (ammette lo 0, es. Spiritualità 0)
-- Esegui UNA volta nel SQL Editor di Supabase. Opzionale: senza, i voti 1–10
-- funzionano comunque, solo lo 0 viene rifiutato.
-- ─────────────────────────────────────────────

alter table po_wheel drop constraint if exists po_wheel_score_check;
alter table po_wheel add constraint po_wheel_score_check check (score between 0 and 10);
