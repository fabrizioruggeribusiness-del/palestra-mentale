-- ─────────────────────────────────────────────
-- Player One — Ottimizzazioni consigliate dagli advisor Supabase
-- Applicata il 25/6/2026 via MCP (apply_migration). Idempotente.
--   1) RLS: (select auth.uid()) → valutato una volta per query, non per riga
--   2) Indici sulle foreign key non ancora coperte da un unique index
-- ─────────────────────────────────────────────

-- 1) RLS più efficiente
drop policy if exists "own_books" on pm_books;
create policy "own_books" on pm_books for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_checkins" on pm_checkins;
create policy "own_checkins" on pm_checkins for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_exercises" on po_exercises;
create policy "own_exercises" on po_exercises for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_workout_logs" on po_workout_logs;
create policy "own_workout_logs" on po_workout_logs for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_habits" on po_habits;
create policy "own_habits" on po_habits for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_habit_days" on po_habit_days;
create policy "own_habit_days" on po_habit_days for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_wheel" on po_wheel;
create policy "own_wheel" on po_wheel for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_weight" on po_weight;
create policy "own_weight" on po_weight for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own_daily_goals" on po_daily_goals;
create policy "own_daily_goals" on po_daily_goals for all using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

-- 2) Indici FK (le altre user_id sono già coperte dai rispettivi unique index)
create index if not exists idx_pm_books_user on pm_books(user_id);
create index if not exists idx_pm_checkins_book on pm_checkins(book_id);
create index if not exists idx_po_daily_goals_user on po_daily_goals(user_id);
create index if not exists idx_po_exercises_user on po_exercises(user_id);
create index if not exists idx_po_habit_days_habit on po_habit_days(habit_id);
create index if not exists idx_po_habits_user on po_habits(user_id);
create index if not exists idx_po_workout_logs_exercise on po_workout_logs(exercise_id);
create index if not exists idx_po_workout_logs_user on po_workout_logs(user_id);
