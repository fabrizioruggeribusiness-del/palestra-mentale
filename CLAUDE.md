# Player One — Contesto per Claude

Repo: `fabrizioruggeribusiness-del/palestra-mentale` (GitHub)
URL live: https://fabrizioruggeribusiness-del.github.io/palestra-mentale/
Supabase (VIVO): `opgqjqztmwujcqtmtlxs.supabase.co` — il vecchio `gnrrcbhmimwwytndpxtm` è morto.
Credenziali: nel `.env` del vault Obsidian (`~/Secondo Cervello Obsidian/.env`)

---

## Cos'è

PWA single-file (`index.html`) su GitHub Pages. "La vita come videogioco" — Fabrizio è il personaggio, vuole diventare il più forte possibile. Evoluzione di Palestra Mentale (11 giugno 2026) → Player One (12 giugno 2026).

## Stack

- Frontend: HTML/CSS/JS vanilla, single file `index.html`
- Backend: Supabase (auth email+password, RLS, REST)
- AI: Claude Haiku 4.5 via `@anthropic-ai/sdk` (`dangerouslyAllowBrowser: true`), chiave API in localStorage SOLO — mai nel repo
- Hosting: GitHub Pages (branch `gh-pages`)
- Offline: localStorage queue (`po_queue`) + snapshot (`po_snapshot`)

## Struttura app (6 tab)

| Tab | Contenuto |
|-----|-----------|
| Piano | **Home** (si apre per prima): focus del mese (area debole), piano 2026 (sola lettura, `PIANO_2026`), andamento Vita/Azione nel tempo (grafico 6 mesi) |
| Ruota | Wheel of Life SVG (8 aree) + avatar pixel art + barra livello |
| Corpo | Log allenamento, storico, 1RM stimato (Epley), PR rilevati |
| Mente | Check-in lettura (ex Palestra Mentale, tabelle `pm_*`) |
| Disciplina | Tracker abitudini, chips Oggi/Ieri, storico mesi, gestione abitudini |
| Config | Chiave API, logout, info |

## Database — tabelle

**Nuove (Player One):** `po_exercises`, `po_workout_logs`, `po_habits`, `po_habit_days`, `po_wheel`  
**Vecchie (Palestra Mentale):** `pm_books`, `pm_checkins` — invariate, Mente le usa ancora

Tutto con RLS. Schema in `player-one-schema.sql`.

## Avatar pixel art

Sprite JRPG retrò: griglie di caratteri → `<rect>` SVG con `crispEdges`.  
3 pose (ingobbito, in piedi, doppio bicipite) × 5 palette + aura + scintille.  
5 stati basati sull'"Azione" = media di Salute Fisica + Tempo Libero + Disciplina: Spento → Inarrestabile.  
Ricaduta-proof: peggiora ma non muore mai.

## Wheel of Life — 8 aree

Allineata alla Ruota della Vita reale di Fabrizio (nota `~/Secondo Cervello Obsidian/08_Obiettivi/Ruota della Vita/2026-06-23.md`). Voto 0–10.

| Area | Tipo |
|------|------|
| Salute Fisica | Auto (log Corpo) |
| Tempo Libero | Auto (dispersioni resistite, ultimi 14gg) |
| Crescita | Autovalutazione mensile |
| Famiglia | Autovalutazione mensile |
| Finanze | Autovalutazione mensile |
| Business | Autovalutazione mensile |
| Mindset | Autovalutazione mensile |
| Spiritualità | Autovalutazione mensile |

Avatar **"Azione"** = Salute + Tempo Libero + Disciplina (le aree d'azione). Centro ruota = **"Vita"** = media di tutte le aree votate. Legenda con trend ▲/▼ (manuali vs mese scorso, auto vs finestra precedente) + box "punto debole" e nudge sulle aree da votare.

## Scheda palestra (SCHEDA_SEED)

5 giornate dal foglio Google "Nuova Scheda":
1. Femorali + Tricipiti
2. Quadricipiti + Bicipiti
3. Spalle + Petto A
4. Dorso
5. Spalle + Petto B

## Abitudini (HABITS_SEED)

13 abitudini dal tracker vault giugno 2026:
- 4 boss (3pt): Sveglia 7:00, Palestra, Macros, Passi 8.000
- 3 standard (2pt): No porno, No social passivi, Lettura 30min
- 2 secondarie (1pt): Meditazione, No schermi pre-sonno
- 4 dispersioni (1pt, ✅=resistito): No videogiochi, No sigarette, No alcol, No cibo spazzatura

21 pt/giorno max. Livelli mensili: Bronzo 280 / Argento 420 / Oro 540 (+50€) / Campione 610 (+100€).  
Soglie riscalate automaticamente se cambiano le abitudini attive.

## Funzioni chiave

- `avatarSVG(st)` — pixel art sprite
- `setHabitState(habitId, day, state, silent)` — optimistic UI + offline queue
- `est1rm(s)`, `best1rm(sets)` — formula Epley
- `qPush/qGet/qSet/qFlush()` — offline queue
- `applyQueueLocally()` — riflette op pending nel local state
- `saveSnapshot/restoreSnapshot()` — offline boot (`po_snapshot`)
- `livelliScalati(ym)` — soglie mensili riscalate su abitudini attive
- `coachContext(recap)` — contesto 7 giorni per Claude; domenica aggiunge settimana precedente
- `renderRuota/renderCorpo/renderDisciplina()` — render tab
- `runCoach()` — prompt diverso feriale (3-4 frasi) vs domenica (5-7 frasi recap)

## Integrazioni automatiche

- Salvare allenamento → spunta boss "Palestra"
- Check-in lettura → spunta abitudine "Lettura"
- XP globale = punti Mente + 10/allenamento + 2/PR + punti abitudini

## Cose da NON fare

- Non aggiungere: feed, badge a pioggia, notifiche push aggressive, cose che trattengono nell'app
- v2 solo dopo 2 settimane di uso reale: sync vault Corpo/Disciplina, avatar con immagini AI, moduli Allianz/Herbalife con KPI, boss fight sugli obiettivi 2026, grafici progressione

## Operatività e backup

- **Progetto Supabase VIVO:** `opgqjqztmwujcqtmtlxs` (app + `player-one/.env`). Vecchio `gnrrcbhmimwwytndpxtm` morto.
- **Login app:** `fabrizioruggeri.business@gmail.com`, password nel `.env` del vault come `SUPABASE_PM_PASSWORD`.
- **Backup automatico:** `~/Secondo Cervello Obsidian/scripts/backup-player-one.mjs`, schedulato ogni giorno alle 8:00 (launchagent `com.fabrizioruggeri.player-one-backup`). Scarica tutte le tabelle → JSON re-importabile in `assets/backups/player-one/` (rotazione 30) + `07_Abitudini/Storico Abitudini.md`. Credenziali nel `.env` del vault (`PLAYER_ONE_URL`, `PLAYER_ONE_ANON_KEY`, `SUPABASE_PM_EMAIL/PASSWORD`). Backup e storico sono gitignored nel vault.
- **Sync note-libri:** `scripts/sync-palestra-mentale.mjs` (launchagent `palestra-sync`, 9:10) → note in `06_Crescita_Personale/Libri/`.
- **Ripristino:** Impostazioni → "Ripristina da backup (JSON)" (upsert per id, ordine FK, idempotente).
- **Stato dati (24/6/2026):** solo dati seed (13 abitudini, 40 esercizi), zero storico — il tracker era bloccato dal crash `giorniLabel`, risolto il 24/6.
- **Migrazione pendente:** `migration-wheel-scale.sql` (check 0–10) da eseguire nel SQL Editor per poter votare 0.

## Sicurezza

- Chiave Anthropic SOLO in localStorage del dispositivo — mai nel codice, mai nel repo
- `.gitignore` deve escludere `.env` (le credenziali Supabase stanno nel `.env` del vault, non qui)
- Non committare mai dati utente, sessioni, chiavi

## Setup per nuovi dispositivi

Vedi `SETUP.md` in questa cartella.
