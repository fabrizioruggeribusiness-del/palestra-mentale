-- ─────────────────────────────────────────────
-- Player One — Corpo: palestra per sessione
-- Ogni allenamento porta la palestra in cui è stato fatto, così i progressi
-- e i PR restano separati per sede (macchinari diversi = baseline diverse).
-- Esegui UNA volta. Idempotente.
-- ─────────────────────────────────────────────

alter table po_workout_logs add column if not exists gym text;

-- Lo storico esistente (gym null) è la palestra abituale.
update po_workout_logs set gym = 'Fit Active Portuense' where gym is null;
