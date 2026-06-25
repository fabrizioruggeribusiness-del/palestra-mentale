-- ─────────────────────────────────────────────
-- Player One — Ruota: punteggi decimali (mezzi voti, es. 6.5)
-- Esegui UNA volta nel SQL Editor di Supabase.
-- ─────────────────────────────────────────────

alter table po_wheel alter column score type numeric(3,1) using score::numeric(3,1);
-- il vincolo 0–10 resta valido anche per i decimali
