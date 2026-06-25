-- ─────────────────────────────────────────────
-- Player One — Mente: avanzamento pagine (boss book HP)
-- Aggiunge il totale pagine ai libri e le pagine lette a ogni sessione.
-- Esegui UNA volta nel SQL Editor di Supabase.
-- ─────────────────────────────────────────────

alter table pm_books    add column if not exists pages      int check (pages is null or pages > 0);
alter table pm_checkins  add column if not exists pages_read int not null default 0 check (pages_read >= 0);

-- Lettura in parallelo: un check-in PER LIBRO al giorno (non più uno solo al giorno).
alter table pm_checkins drop  constraint if exists pm_checkins_user_id_day_key;
alter table pm_checkins add   constraint pm_checkins_user_book_day_key unique (user_id, book_id, day);
