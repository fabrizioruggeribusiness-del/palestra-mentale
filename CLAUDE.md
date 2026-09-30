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
| Corpo | **Blocco** (settimana, switch piena/minima, deload, avvisi), log allenamento con prescrizione del giorno + timer recupero + suggerimento progressione, 1RM stimato (Epley), PR, peso, **palestra per sessione**, **condizionamento** (vogatore/sacco/MMA/corda) + **corsa**, **mobilità**, **volume per gruppo**, **benchmark S0/S8**. **Storico:** grafico 1RM+volume per esercizio (per palestra), Record, Diario (una riga per giornata, si apre col tap), heatmap |
| Mente | Lettura come gioco: check-in giornaliero, **boss book** (barra HP pagine), **striscia** 🔥, **codex** (estratti passati a rotazione), **quest 📚 X/24** annuale. Tabelle `pm_*` |
| Disciplina | Tracker abitudini, chips Oggi/Ieri, storico mesi, gestione abitudini |
| Config | Chiave API, logout, info |

## Database — tabelle

**Nuove (Player One):** `po_exercises` (col. `plan`, `variant`, `sets_target`, `reps_target`, `rest_sec`, `rpe`, `rir`, `big_lift`, `is_core`, `muscle`, `note`), `po_workout_logs` (col. `gym`), `po_habits`, `po_habit_days`, `po_wheel`, `po_weight`, `po_runs`, `po_block`, `po_conditioning`, `po_mobility`, `po_benchmarks`  
**Vecchie (Palestra Mentale):** `pm_books`, `pm_checkins` — invariate, Mente le usa ancora

Tutto con RLS. Schema in `player-one-schema.sql`.

## Avatar pixel art

Sprite JRPG retrò: griglie di caratteri → `<rect>` SVG con `crispEdges`.  
3 pose (ingobbito, in piedi, doppio bicipite) × 5 palette + aura + scintille.  
5 stati basati sull'"Azione" = media di Salute Fisica + Tempo Libero + Disciplina: Spento → Inarrestabile.  
Ricaduta-proof: peggiora ma non muore mai.

## Wheel of Life — 8 aree

Allineata alla Ruota della Vita reale di Fabrizio (nota `~/Secondo Cervello Obsidian/08_Obiettivi/Ruota della Vita/2026-06-23.md`). Voto 0–10.

Tutte e 8 le aree (Salute Fisica, Crescita, Tempo Libero, Famiglia, Finanze, Business, Mindset, Spiritualità) sono **autovalutazione mensile manuale**, scala **0–10 decimale** (mezzi voti). `po_wheel.score` è `numeric(3,1)`.

Avatar **"Azione"** = dati reali, calcolata da `corpoAt`+`tempoAt`+`disciplinaAt` (allenamenti, dispersioni, abitudini) — **indipendente** dai voti della ruota. Centro ruota = **"Vita"** = media degli 8 voti. Legenda: trend ▲/▼ vs mese scorso, oppure "prima X" col pulsante **Confronta col mese scorso** (overlay bianco sul gradino del mese scorso). Box "punto debole" + nudge sulle aree da votare.

## Scheda palestra — blocco ibrido (dal 24/9/2026)

Fonte: `TRAINING_PLAN.md` in questa cartella. **È la fonte di verità: non inventare esercizi, serie o progressioni che non ci sono.** Le costanti `SEDUTE`, `COND`, `MUSCLE_UP`, `VOLUME_TARGET`, `MOBILITA`, `BENCHMARKS` in `index.html` ne sono la trascrizione.

Blocco di 8 settimane (`PLAN_ID = 'ibrido-2026-09'`), poi "blocco 2 / ponte dicembre": progressione congelata, RPE 7, mantenimento fino al parto.

**Versione piena** (5 sedute + 2 facoltative): Lunedì Lower B (hinge) · Martedì Upper A (push) · Mercoledì riposo · Giovedì Lower A (quad) · Venerdì Upper B (pull, muscle-up a fresco) · Sabato full body + MMA tecnica · Domenica corsa lunga facoltativa.
**Versione minima** (4 sedute, RPE 6-7): il "piano B" quando la settimana si stringe. Le due sedute di pesi sono **simmetriche** (entrambe spinta+tirata+ginocchio+anca, 4 serie): saltandone una hai comunque toccato tutto il corpo. 8 serie/settimana sui gruppi grandi.
**Versione casa** (chip "Casa", 2 sedute alternate, 20-25'): il piano C con manubri 2-10 kg, manubrio 18 kg e corda. Stessa simmetria, 3 serie, fascia volume 6-8.

Switch fra le tre in un tap, **nessuna penalità, nessuna striscia interrotta** — il linguaggio è parte del piano: mai "hai saltato". In minima e casa il suggerimento di progressione tace: lì si mantiene, non si cresce.

**Revisioni della scheda:** `syncVariant(v)` riallinea una versione alle costanti quando la scheda cambia, ma **solo se su quella versione non è mai stata registrata una serie**. Se ci hai già allenato o hai aggiunto esercizi a mano, la lascia stare. Per cambiare una versione già usata serve una scelta esplicita.

Logiche implementate: doppia progressione, timer di recupero (superset = 15" + 75"), volume settimanale per gruppo vs target, allarme calo big lift → taglia il condizionamento (non cibo né sonno), scarico manuale (accessori -50%, big lift invariati), progressioni condizionamento e muscle-up per fascia di settimane, checklist mobilità separata dai pesi, benchmark settimana 0/8.

⚠️ **La card Proteine non esiste più** (30/9/2026): era una moltiplicazione che non cambia mai. Il numero (2,0-2,2 g/kg) vive come nota in "Come funziona il piano", calcolato da `notaProteine()` sull'ultimo peso o su `PESO_FALLBACK`. La card **Peso resta**, per scelta esplicita di Fabrizio, anche se `po_weight` è vuota.

### ⚠️ L'app conta e mostra, non decide (30/9/2026)

Tre scelte esplicite di Fabrizio. Non sono bug e non vanno "risistemate" senza chiederglielo.

1. **La settimana del piano avanza col lavoro, non col calendario.** `blockWeek() = 1 + settimaneAllenate()`, dove una settimana conta se ha ≥ `MIN_SEDUTE_SETT` (2) giorni con log; la settimana in corso non è contata finché non finisce, così la prescrizione non cambia sotto le mani. `calWeek()`/`calWeekNow()` restano la settimana di **calendario**, usate solo per raggruppare i log (volume settimanale, trend big lift). `weekBand()` non prende più una data: la fascia è una sola, quella del piano.
2. **Lo scarico è un chip, non una data.** `isDeload()` legge `localStorage.po_deload` (giorno di accensione) e vale 7 giorni, poi scade da sé; `toggleDeload()` lo accende e spegne. Niente colonna nuova su `po_block`, niente migrazione. Spariti `deloadGiaSvolto` e il deload automatico alla settimana 6.
3. **Gli avvisi sono fatti.** `triggerMinima()` è stata rimossa (sedute non fatte, RPE fuori scala, minima post-parto): resta solo `bigLiftAlert()`, che parla di interferenza e non di costanza. Al suo posto `settimanaOra()` → riga neutra "questa settimana: N sedute · M serie" nella card Blocco.

**Buchi del piano chiusi il 30/9/2026** (un esercizio solo): il martedì il push-down va in superset col **reverse fly** invece che col French press, che diventa una serie normale con 90" di recupero. Risolve insieme il superset agonista tricipiti+tricipiti e le 4 serie mancanti di deltoidi posteriori → **12/12 su ogni gruppo, 115 serie dirette su 115** (verificato sulle costanti). `syncVariant` gira ora anche su `piena`, così la revisione entra da sola nella scheda finché non ci sono log su quella versione.

Altre regole del blocco, dallo stesso giro di correzioni:
- **Corpo libero registrabile:** `parseSets` accetta le sole ripetizioni (`12, 10, 8`) oltre a `peso x reps`. Peso 0 = a corpo libero: conta nel volume e nello storico, fa record **sulle ripetizioni**, e non viene mai confrontato con le sessioni zavorrate (`bwOnly`/`scoreLog`). Serviva a trazioni, dip, push-up, plank e a tutta la progressione muscle-up.
- **Deload (settimana 6):** anche i *target* del volume si dimezzano sugli accessori (`targetGruppo`), big lift esclusi. Prima le barre dicevano "ti manca" nella settimana in cui fare meno è la prescrizione.
- **Sedute saltate:** `triggerMinima` conta i giorni che hanno davvero esercizi, non i giorni passati — il riposo del mercoledì e la domenica facoltativa non sono sedute mancate.
- **Muscle-up raggiunto:** pulsante nella riga dello skill → benchmark `muscle_up`, da cui `muscleUpPresc` passa al consolidamento (prima il ramo esisteva ma non c'era modo di accenderlo).
- **Record:** solo il blocco corrente, aggregati per **nome + palestra** (le righe archiviate dello stesso nome sono lo stesso esercizio).
- **Condizionamento:** si registra qualunque tipo in qualunque giorno (select + data), non solo il finisher della giornata aperta. Corsa e condizionamento spuntano l'abitudine **Cardio** (`tickCardio`), come l'allenamento spunta Palestra.
- ⚠️ **Inizio blocco e data del parto: nessun campo, per scelta esplicita di Fabrizio (30/9/2026).** Era stata aggiunta una card in Impostazioni e lui l'ha fatta togliere: *quando* passare da una versione all'altra lo decide lui, con i chip Piena/Minima/Casa. Conseguenza da conoscere e non "correggere": `start_date` resta a `DEFAULT_BLOCK_START` e `birth_date` resta vuota, quindi `postPartum()` (minima automatica per 4 settimane dal parto) non scatta mai, a meno di scrivere la data a mano su `po_block`. Il codice resta, il campo no.

⚠️ La scheda vecchia (5 giornate dal foglio "Nuova Scheda") è archiviata con `active = false`: lo storico resta agganciato alle sue righe ma fuori dai PR del blocco nuovo (scelta esplicita di Fabrizio: ripartire puliti).

**Storico per nome, non per riga:** il curl del lunedì e quello del venerdì sono lo stesso esercizio — `logsOfEx()` unisce i log per `name` dentro lo stesso `plan`.

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
- `renderPiano/renderRuota/renderCorpo/renderDisciplina/renderMente()` — render tab
- `renderCodex/renderCodexList()` — codex (estratto del giorno + archivio sfogliabile)
- `readStreak()` — striscia di lettura (giorni consecutivi)

> Nota: il "coach AI" (runCoach/coachContext) è stato rimosso; non c'è più nessuna chiave API nell'app.

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
- **Aggiornamento mattutino Obsidian (job unico, 10:00):** launchagent `com.fabrizioruggeri.player-one-morning` → `scripts/morning-obsidian-sync.sh`, che esegue in sequenza `backup-player-one.mjs` (JSON re-importabile in `assets/backups/player-one/`, rotazione 30, + `07_Abitudini/Storico Abitudini.md`) e `sync-palestra-mentale.mjs` (note per libro in `06_Crescita_Personale/Libri/`). Consolidato il 25/6/2026 dai due vecchi job (backup 8:00 + sync 9:10, ora rimossi). Credenziali nel `.env` del vault. Backup e storico gitignored. Log: `scripts/reports/cron.log`.
- **Ripristino:** Impostazioni → "Ripristina da backup (JSON)" (upsert per id, ordine FK, idempotente).
- **Stato dati (24/6/2026):** solo dati seed (13 abitudini, 40 esercizi), zero storico — il tracker era bloccato dal crash `giorniLabel`, risolto il 24/6.
- **Deploy live (manuale, NO CI):** GitHub Pages serve dal branch `gh-pages`. Si lavora su `main`; per pubblicare: `git push origin main && git push origin main:gh-pages --force`. (Storicamente `gh-pages` era rimasto a v6 mentre `main` era a v25 → riallineato il 25/6/2026.) Bump `sw.js` CACHE a ogni deploy, poi chiudere/riaprire la PWA.
- **Migrazioni eseguite:** applicate al 25/6/2026: `migration-mente-pages.sql` (pages/pages_read + `unique(user_id, book_id, day)` = un check-in per libro al giorno; Fabrizio legge 3 libri in parallelo).
- **Migrazione eseguita (25/6/2026):** `migration-daily-goals.sql` → tabella `po_daily_goals` (obiettivi del giorno nel cloud). Applicata via Management API. Al primo boot i vecchi obiettivi localStorage salgono in automatico.
- **Corpo — super serie + RPE (25/6/2026, via MCP):** colonna `po_exercises.superset_group` (lettera; stessa lettera+giornata = superset, badge 🔗 + bordo oro). Intensità per serie via sintassi `90x7@8` (RPE 1–10, opzionale, salvata in `sets[].rpe`); `parseSets`/`fmtSets`/`avgRpe` la gestiscono.
- **Ottimizzazioni DB (25/6/2026, via MCP):** `migration-rls-indexes.sql` — RLS riscritte con `(select auth.uid())` (no rivalutazione per riga) + indici sulle FK scoperte. Advisor performance WARN risolti; restano solo INFO `unused_index` (normale per indici nuovi). Security: resta solo "leaked password protection" da abilitare nel dashboard Auth.
- **Migrazioni d'ora in poi (via Management API o MCP locale):** con il Personal Access Token in `.env` del vault (`SUPABASE_ACCESS_TOKEN`, `sbp_***`) si esegue qualsiasi SQL/DDL senza SQL Editor: `POST https://api.supabase.com/v1/projects/opgqjqztmwujcqtmtlxs/database/query` con header `Authorization: Bearer $SUPABASE_ACCESS_TOKEN` e body `{"query":"..."}`. (Il Supabase MCP hosted HTTP dà errore OAuth "resource" — non usarlo; la Management API lo sostituisce.)
- **Offline-proof:** la coda offline (`po_queue`/dead-letter) copre abitudini, ruota, allenamenti **e** (dal 25/6) check-in lettura, peso, aggiungi/rimuovi libro, obiettivi del giorno, **corse** (kind `run`/`run_del`). Op con id generato lato client (`crypto.randomUUID`) → idempotenti.
- **Corpo — palestra per sessione (26/6/2026):** `migration-gym.sql` → colonna `po_workout_logs.gym` (backfill storico = `Fit Active Portuense`). Selettore palestra corrente (`localStorage po_gym`); **PR, record e grafici 1RM/volume separati per palestra** (chiave `exercise_id|gym`, helper `gymOf`) così cambiare sede non genera cali finti. Default `DEFAULT_GYM = 'Fit Active Portuense'`.
- **Corpo — blocco ibrido (24/9/2026):** `migration-blocco-ibrido.sql` → metadati su `po_exercises` + tabelle `po_block` (settimana/modalità/data parto), `po_conditioning`, `po_mobility`, `po_benchmarks`. **L'app degrada in modo pulito se la migrazione non è stata eseguita:** `planReady = false` → resta la scheda precedente + banner, nessuna schermata rotta. La semina del blocco è idempotente (`seedPlan()` gira solo se non ci sono righe attive con `plan = PLAN_ID`). ✅ **Migrazione eseguita:** confermata dal backup del 30/9/2026 (`po_block` popolata, 60 esercizi attivi su `ibrido-2026-09` — 36 piena + 12 minima + 12 casa, la scheda vecchia a `active = false`). ⚠️ Resta vero che il PAT `SUPABASE_ACCESS_TOKEN` nel `.env` del vault è **revocato** dal 24/9/2026: le prossime migrazioni si eseguono dal SQL Editor finché non se ne genera uno nuovo.
- **Corpo — corsa facoltativa (26/6/2026):** `migration-runs.sql` → tabella `po_runs` (distanza, durata, tipo, FC, note; passo calcolato). Sezione "🏃 Corsa" nel tab Corpo. **Bonus `RUN_XP = 8` per uscita, nessuna penalità** (non spunta boss Palestra, non tocca l'avatar "Azione"). `parseTime`/`fmtDur`/`fmtPace`, `renderRuns`.

## Sicurezza

- Chiave Anthropic SOLO in localStorage del dispositivo — mai nel codice, mai nel repo
- `.gitignore` deve escludere `.env` (le credenziali Supabase stanno nel `.env` del vault, non qui)
- Non committare mai dati utente, sessioni, chiavi

## Setup per nuovi dispositivi

Vedi `SETUP.md` in questa cartella.
