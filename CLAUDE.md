# Player One — Contesto per Claude

Repo: `fabrizioruggeribusiness-del/palestra-mentale` (GitHub)
URL live: https://fabrizioruggeribusiness-del.github.io/palestra-mentale/
Supabase: `gnrrcbhmimwwytndpxtm.supabase.co`
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

## Struttura app (5 tab)

| Tab | Contenuto |
|-----|-----------|
| Ruota | Home: Wheel of Life SVG (8 aree) + avatar pixel art + barra livello |
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
5 stati basati sulla media aree attive (Corpo/Mente/Disciplina): Spento → Inarrestabile.  
Ricaduta-proof: peggiora ma non muore mai.

## Wheel of Life — 8 aree

| Area | Tipo |
|------|------|
| Corpo | Auto (da log Corpo) |
| Mente | Auto (da check-in Mente) |
| Disciplina | Auto (da tracker abitudini) |
| Famiglia | Autovalutazione mensile 1–10 |
| Allianz | Autovalutazione mensile 1–10 |
| Herbalife | Autovalutazione mensile 1–10 |
| Brand | Autovalutazione mensile 1–10 |
| Finanze | Autovalutazione mensile 1–10 |

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

## Sicurezza

- Chiave Anthropic SOLO in localStorage del dispositivo — mai nel codice, mai nel repo
- `.gitignore` deve escludere `.env` (le credenziali Supabase stanno nel `.env` del vault, non qui)
- Non committare mai dati utente, sessioni, chiavi

## Setup per nuovi dispositivi

Vedi `SETUP.md` in questa cartella.
