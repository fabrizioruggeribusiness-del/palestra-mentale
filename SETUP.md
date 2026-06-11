# Setup — Palestra Mentale

Tre passi manuali (~10 minuti totali), poi Claude chiude il cablaggio.

---

## 1️⃣ Tabelle Supabase (~2 min)

Stesso progetto di Fabrizio RPG, tabelle nuove.

1. Vai su https://supabase.com → progetto `fabrizio-rpg`
2. **SQL Editor** → incolla tutto `supabase-schema.sql` → **Run**
3. **Authentication → Providers → Email**: verifica che "Email + Password" sia abilitato
   (per Palestra Mentale si usa email+password, non magic link — così anche lo script
   sul Mac può sincronizzare il vault con le stesse credenziali)

> Al primo accesso nell'app: "Crea l'account" con la tua email e una password.
> Poi aggiungi nel `.env` del vault:
> ```
> SUPABASE_PM_EMAIL=la-tua-email
> SUPABASE_PM_PASSWORD=la-tua-password
> ```
> Il sync vault (cron 09:10) scriverà le note in `06_Crescita_Personale/Libri/`.

## 2️⃣ Repo GitHub + Pages (~3 min)

> ⚠️ Repo separato, NON il vault. Qui non ci sono dati sensibili: può essere pubblico.

1. https://github.com/new → nome `palestra-mentale` · **Public** · senza README
2. Copia l'URL SSH (`git@github.com:TUONOME/palestra-mentale.git`) e dammelo: pusho io
3. Dopo il push: repo → **Settings → Pages → Source: main / root → Save**
4. Dopo ~1 min: `https://TUONOME.github.io/palestra-mentale/`

**iPhone:** apri l'URL in Safari → Condividi → *Aggiungi a Home*.

## 3️⃣ Chiave API Claude (~5 min)

La valutazione AI gira con Claude Haiku direttamente dal browser. La chiave resta
SOLO nel localStorage del tuo dispositivo — mai nel codice, mai su GitHub.

1. https://console.anthropic.com → crea account (serve carta, ricarica minima 5$)
2. **API Keys → Create Key** → copia la chiave `sk-ant-...`
3. Nell'app: tab **⚙️ Altro → Chiave API Claude → Salva**
   (va fatto una volta per dispositivo: una su iPhone, una sul Mac se la usi lì)

> 💰 Costo reale: un check-in al giorno con Haiku ≈ mezzo centesimo. I 5$ durano anni.

---

## Checklist per chiudere

- [ ] SQL eseguito su Supabase
- [ ] URL SSH del repo `palestra-mentale` → a Claude per il push
- [ ] Account creato nell'app + credenziali nel `.env` del vault
- [ ] Chiave API salvata in ⚙️ sull'iPhone
