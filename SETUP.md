# Setup — Player One

App live: https://fabrizioruggeribusiness-del.github.io/palestra-mentale/

Player One = la vita come videogioco. Home: Ruota della Vita + avatar.
Moduli attivi: 🏋️ Corpo (scheda + carichi) · 🧠 Mente (ex Palestra Mentale) · ⚔️ Disciplina (abitudini).
Aree a autovalutazione mensile: Famiglia, Allianz, Herbalife, Brand, Finanze.

---

## Migrazione Player One (~1 min, una volta sola)

1. https://supabase.com → progetto → **SQL Editor**
2. Incolla tutto `player-one-schema.sql` → **Run**
3. Ricarica l'app: al primo avvio semina da sola scheda palestra e abitudini

Le tabelle `pm_books` / `pm_checkins` (modulo Mente) restano invariate:
nessun dato perso.

## Chiave API Claude

La valutazione lettura e il coach girano con Claude Haiku direttamente dal
browser. La chiave resta SOLO nel localStorage del dispositivo — mai nel
codice, mai su GitHub (repo pubblico).

1. https://console.anthropic.com → **API Keys → Create Key**
2. Nell'app: **⚙️ Altro → Chiave API Claude → Salva**
   (una volta per dispositivo: iPhone e Mac separatamente)

> 💰 Un check-in o un discorso del coach ≈ frazioni di centesimo. I 5$ durano anni.

## iPhone

Apri l'URL in Safari → Condividi → **Aggiungi a Home**.

## Sync vault (già attivo)

`scripts/sync-palestra-mentale.mjs` nel vault legge `pm_books`/`pm_checkins`
con le credenziali nel `.env` e scrive le note in `06_Crescita_Personale/Libri/`
(launchd, ogni giorno alle 09:10).

---

## Storico setup originale (Palestra Mentale v1)

- Tabelle `pm_*`: `supabase-schema.sql` (già eseguito l'11 giugno 2026)
- Auth email+password (non magic link) per condividere le credenziali con lo script vault
- Account: vedi `.env` del vault
