# Piano di allenamento ibrido — Fabrizio

> **Scopo di questo file:** specifica completa da dare a Claude Code per modificare un'app di tracking allenamenti.
> Contiene: (1) contesto atleta, (2) dati strutturati in JSON pronti da parsare, (3) regole logiche da implementare, (4) note di allenamento che l'app deve mostrare all'utente.
>
> **Per l'agente di sviluppo:** i blocchi JSON sono la fonte di verità per i dati. La prosa attorno serve a capire il perché e a scrivere i testi in-app. Non inventare esercizi, serie o progressioni non presenti qui.

---

## 1. Contesto atleta

| Campo | Valore |
|---|---|
| Nome | Fabrizio |
| Età | 31 |
| Peso stimato di partenza | ~85 kg |
| BF stimata di partenza | ~26% |
| Background | Bodybuilding pluriennale, ottima tecnica, memoria muscolare |
| Infortuni | Nessuno, storico e attuale |
| Fase alimentare | Deficit calorico (body recomposition) |
| Sonno attuale | 8h+ |
| Tempo per seduta (feriale) | 90' in pausa pranzo |
| Weekend | Disponibile, senza vincoli di orario |
| Attrezzatura palestra | Completa (bilancieri, macchine, cavi doppi, sbarra, anelli, sacco, tappeti) |
| Attrezzatura casa | Manubri modulabili 2-10 kg x2, manubrio singolo 18 kg, corda |
| Corsa | Pista ciclabile sotto casa, cardiofrequenzimetro disponibile |

**Obiettivi**
- Breve termine: 75 kg / 8-10% BF
- Lungo termine: ~80 kg / ~8% BF, muscle-up, capacità di correre una mezza maratona
- Trasversale: essere un padre atletico, con energia per giocare col figlio

**Priorità dichiarate (in ordine)**
1. Sala pesi (ipertrofia e forza) — pilastro
2. Condizionamento: MMA/sacco misto + corsa (la corsa è strumento al servizio del combattimento)
3. Mobilità e postura — lavoro dedicato, non riempitivo

**Vincolo critico**
Nascita del figlio a dicembre 2026. Supporto familiare presente, ma sonno e prevedibilità caleranno.
Profilo psicologico "tutto o niente": se salta troppo, perde lo stimolo. Per questo l'app deve gestire **due versioni del piano** (piena e minima) e far percepire la minima come "piano B legittimo", mai come fallimento.

---

## 2. Dati strutturati

### 2.1 Split settimanale

```json
{
  "split": [
    { "day": "lunedi",   "focus": "Lower B (hinge)",  "core": "anti-estensione",   "finisher": "vogatore_lungo" },
    { "day": "martedi",  "focus": "Upper A (push)",   "core": "flessione",         "finisher": "mma_sacco",      "warmup_extra": "corda_5_8min" },
    { "day": "mercoledi","focus": "riposo",           "core": null,                "finisher": "mobilita_casa_10_12min" },
    { "day": "giovedi",  "focus": "Lower A (quad)",   "core": "anti-rotazione",    "finisher": "vogatore_corto" },
    { "day": "venerdi",  "focus": "Upper B (pull)",   "core": "obliqui",           "finisher": "corsa_z2_facile" },
    { "day": "sabato",   "focus": "Full body",        "core": "circuito",          "finisher": "mma_tecnica_30min", "warmup_extra": "corda_5_8min", "extra": "mobilita_estesa_15_20min" },
    { "day": "domenica", "focus": "facoltativo",      "core": null,                "finisher": "corsa_z2_lunga", "optional": true }
  ]
}
```

**Logica dello split (da mostrare in-app come testo esplicativo):**
- I big lift vanno sempre a inizio seduta, freschi, con recuperi pieni. Mai in superset.
- Il condizionamento viene sempre dopo i pesi: in deficit calorico la forza è la prima cosa da proteggere.
- Vogatore (zero impatto) nei giorni gambe; corsa (impatto) nei giorni upper. Il carico sulle gambe non si somma.
- Quad e catena posteriore separati in due giorni: pattern diversi, uno recupera mentre lavora l'altro.
- Mercoledì riposo pieno al centro della settimana, per non arrivare al weekend svuotato.

### 2.2 Sedute

```json
{
  "sessions": {
    "lunedi": {
      "name": "Lower B (hinge)",
      "exercises": [
        { "name": "Stacco rumeno",         "sets": 4, "reps": "8-10",  "rest_sec": 150, "rpe": 8,   "rir": 2, "big_lift": true },
        { "name": "Hip thrust",            "sets": 4, "reps": "10-12", "rest_sec": 120, "rpe": 8,   "rir": 2, "big_lift": true },
        { "name": "Leg curl",              "sets": 4, "reps": "15",    "rest_sec": 90,  "rpe": 9,   "rir": 1 },
        { "name": "Step-up o affondi in cammino", "sets": 3, "reps": "10 per lato", "rest_sec": 90, "rpe": 8 },
        { "superset": [
            { "name": "Polpacci seduto",   "sets": 4, "reps": "15-20", "rpe": 8, "rir": 2 },
            { "name": "Curl bicipiti",     "sets": 3, "reps": "10-12", "rpe": 9, "rir": 1 }
          ], "rest_sec": 75 },
        { "name": "Plank o Stir the pot",  "sets": 3, "reps": "30-45 sec", "rest_sec": 60, "core": true }
      ],
      "finisher": "vogatore_lungo"
    },

    "martedi": {
      "name": "Upper A (push)",
      "exercises": [
        { "name": "Panca piana bilanciere",    "sets": 4, "reps": "6-8",   "rest_sec": 150, "rpe": 8, "rir": 2, "big_lift": true },
        { "name": "Panca inclinata manubri",   "sets": 4, "reps": "8-10",  "rest_sec": 120, "rpe": 8, "rir": 2, "big_lift": true },
        { "name": "Dip o chest press",         "sets": 4, "reps": "10-12", "rest_sec": 90,  "rpe": 8, "rir": 2 },
        { "superset": [
            { "name": "Alzate laterali",       "sets": 4, "reps": "12-15", "rpe": 9, "rir": 1 },
            { "name": "Face pull",             "sets": 4, "reps": "15",    "rpe": 8 }
          ], "rest_sec": 75 },
        { "superset": [
            { "name": "Push-down tricipiti",   "sets": 4, "reps": "12-15", "rpe": 9, "rir": 1 },
            { "name": "French press",          "sets": 3, "reps": "12",    "rpe": 9, "rir": 1 }
          ], "rest_sec": 75 },
        { "name": "Cable crunch",              "sets": 3, "reps": "12-15", "rest_sec": 60, "core": true }
      ],
      "warmup_extra": "corda_5_8min",
      "finisher": "mma_sacco"
    },

    "mercoledi": {
      "name": "Riposo",
      "exercises": [],
      "note": "Mobilità pura 10-12' la sera a casa: colonna toracica, anche, spalle. Zero training."
    },

    "giovedi": {
      "name": "Lower A (quad)",
      "exercises": [
        { "name": "Squat bilanciere o hack squat", "sets": 4, "reps": "6-8",   "rest_sec": 150, "rpe": 8, "rir": 2, "big_lift": true },
        { "name": "Leg press",                     "sets": 4, "reps": "10-12", "rest_sec": 120, "rpe": 8, "rir": 2, "big_lift": true },
        { "superset": [
            { "name": "Leg extension",             "sets": 3, "reps": "15",    "rpe": 9, "rir": 1 },
            { "name": "Polpacci in piedi",         "sets": 4, "reps": "12-15", "rpe": 8 }
          ], "rest_sec": 75 },
        { "name": "Affondi bulgari",               "sets": 3, "reps": "10 per lato", "rest_sec": 90, "rpe": 8, "rir": 2 },
        { "name": "Alzate laterali ai cavi",       "sets": 4, "reps": "15",    "rest_sec": 60, "rpe": 9, "rir": 1 },
        { "name": "Pallof press",                  "sets": 3, "reps": "12 per lato", "rest_sec": 60, "core": true }
      ],
      "finisher": "vogatore_corto"
    },

    "venerdi": {
      "name": "Upper B (pull)",
      "exercises": [
        { "name": "Skill muscle-up", "position": "inizio seduta, a fresco", "rest_sec": 120, "note": "tecnica, mai a cedimento", "progression_ref": "muscle_up" },
        { "name": "Trazioni zavorrate",         "sets": 4, "reps": "6-8",   "rest_sec": 150, "rpe": 8, "rir": 2, "big_lift": true },
        { "name": "Rematore bilanciere o manubrio", "sets": 4, "reps": "8-10", "rest_sec": 120, "rpe": 8, "rir": 2, "big_lift": true },
        { "name": "Lat machine presa larga",    "sets": 4, "reps": "10-12", "rest_sec": 90, "rpe": 8, "rir": 2 },
        { "superset": [
            { "name": "Curl bicipiti",          "sets": 4, "reps": "10-12", "rpe": 9, "rir": 1 },
            { "name": "Reverse fly",            "sets": 4, "reps": "15",    "rpe": 8 }
          ], "rest_sec": 75 },
        { "name": "Russian twist zavorrato",    "sets": 3, "reps": "15 per lato", "rest_sec": 60, "core": true }
      ],
      "finisher": "corsa_z2_facile"
    },

    "sabato": {
      "name": "Full body + MMA tecnica",
      "exercises": [
        { "name": "Alzate laterali o Arnold press", "sets": 3, "reps": "12-15", "rest_sec": 90, "rpe": 8 },
        { "superset": [
            { "name": "Cable fly",                  "sets": 4, "reps": "15", "rpe": 8 },
            { "name": "Pulley basso",               "sets": 4, "reps": "15", "rpe": 8 }
          ], "rest_sec": 75 },
        { "name": "Leg press o goblet squat",       "sets": 3, "reps": "15", "rest_sec": 90, "rpe": 6.5, "note": "frequenza extra gambe, non stimolo massimale" },
        { "superset": [
            { "name": "Curl bicipiti",              "sets": 3, "reps": "12-15", "rpe": 8.5 },
            { "name": "Estensioni tricipiti",       "sets": 3, "reps": "12-15", "rpe": 8.5 }
          ], "rest_sec": 60 },
        { "name": "Dead bug + hollow hold + plank laterale", "sets": 2, "reps": "circuito, 2 giri", "core": true }
      ],
      "warmup_extra": "corda_5_8min",
      "finisher": "mma_tecnica_30min",
      "extra": "mobilita_estesa_15_20min"
    },

    "domenica": {
      "name": "Facoltativa",
      "optional": true,
      "exercises": [],
      "finisher": "corsa_z2_lunga",
      "extra": "stretching_mirato_5_8min"
    }
  }
}
```

### 2.3 Progressioni condizionamento (8 settimane)

```json
{
  "conditioning_progressions": {
    "vogatore_lungo": {
      "day": "lunedi",
      "weeks": {
        "1-2": "6 x 1' forte / 1'30\" facile",
        "3-4": "8 x 1' forte / 1' facile",
        "5-6": "5 x 2' moderato-alto / 1'30\" facile",
        "7-8": "4 x 3' alto / 2' facile"
      }
    },
    "vogatore_corto": {
      "day": "giovedi",
      "weeks": {
        "1-2": "8 x 30\" forte / 1'30\" facile",
        "3-4": "10 x 30\" forte / 1' facile",
        "5-6": "6 x 1' forte / 1' facile",
        "7-8": "5 x 1'30\" alto / 1' facile"
      }
    },
    "mma_sacco": {
      "day": "martedi",
      "weeks": {
        "1-2": { "rounds": "4 x 2'", "rest": "1'", "focus": "pugni + calci bassi", "kick_intensity_pct": 50, "shin_guards": true },
        "3-4": { "rounds": "5 x 2'", "rest": "1'", "focus": "+ ginocchia da clinch, combo pugni-calcio", "kick_intensity_pct": 70, "shin_guards": true },
        "5-6": { "rounds": "5 x 3'", "rest": "1'", "focus": "combo 3-4 colpi, cambi di livello", "kick_intensity_pct": 100 },
        "7-8": { "rounds": "6 x 3'", "rest": "1'", "focus": "combo complete + difesa e contrattacco", "kick_intensity_pct": 100 }
      }
    },
    "mma_tecnica_30min": {
      "day": "sabato",
      "duration_min": 30,
      "note": "Senza cronometro. Schivate, parate, clinch, gestione della distanza. Qualità, non condizionamento."
    },
    "corsa_z2_facile": {
      "day": "venerdi",
      "weeks": { "1-2": "15-18' continui", "3-4": "18-22'", "5-6": "22-25'", "7-8": "25-30'" }
    },
    "corsa_z2_lunga": {
      "day": "domenica",
      "optional": true,
      "weeks": { "1-2": "20' continui", "3-4": "25-30'", "5-6": "30-35'", "7-8": "35-45'" }
    },
    "corda_5_8min": {
      "days": ["martedi", "sabato"],
      "duration_min": "5-8",
      "role": "warm-up specifico per footwork, non cardio generico"
    }
  }
}
```

**Definizione Z2:** frequenza cardiaca a cui si riesce a parlare a frasi intere senza affanno, orientativamente 70-80% FCmax. L'app dovrebbe avvisare se l'utente registra una Z2 costantemente sopra soglia: la base aerobica si costruisce restando facili, non spingendo.

### 2.4 Progressione muscle-up

```json
{
  "muscle_up": {
    "position": "inizio seduta venerdì, a fresco",
    "weeks": {
      "1-2": "Trazioni esplosive al petto 4x5 + dip su anelli 3x8",
      "3-4": "Trazioni al petto/sterno 4x4 + negative muscle-up 3x3 (discesa 5\")",
      "5-6": "Negative 4x3 + transizione assistita con elastico 3x3",
      "7-8": "Tentativi muscle-up 5x1-2 (freschissimo) + negative 2x3"
    },
    "if_achieved_early": {
      "mode": "consolidamento",
      "prescription": "4-5 x 1-2 reps pulite",
      "max_total_reps_per_session": 10,
      "note": "Skill sul sistema nervoso, non esercizio di ipertrofia. Fermarsi lontano dalla fatica è ciò che lo rende stabile."
    }
  }
}
```

### 2.5 Volume settimanale target

```json
{
  "weekly_volume_targets": {
    "petto": 16, "dorso": 16, "quadricipiti": 17, "femorali_glutei": 15,
    "deltoidi_laterali": 11, "deltoidi_posteriori": 12,
    "bicipiti": 10, "tricipiti": 10, "polpacci": 8
  },
  "total_direct_sets": 115,
  "note": "Fascia alta del range produttivo per un avanzato in deficit calorico. Oltre questo si aggiunge fatica più che stimolo."
}
```

L'app dovrebbe calcolare il volume effettivo per gruppo muscolare e segnalare gli scostamenti da questi target — è il modo per accorgersi in anticipo che una modifica alla scheda ha sbilanciato qualcosa.

> **Nota di implementazione (24/9/2026):** gli esercizi elencati nella sezione 2.2 producono **8 serie di deltoidi posteriori contro le 12 dichiarate** qui, e **111 serie dirette totali contro 115**. Tutti gli altri gruppi tornano esatti. Lo scostamento è reale e l'app lo mostra nella card Volume: va deciso, non corretto in silenzio.

### 2.6 Mobilità

```json
{
  "mobility": {
    "lunedi":    { "warmup_min": "8-10", "cooldown_min": 5, "type": "dinamica + stretching" },
    "martedi":   { "warmup_min": "8-10", "cooldown_min": 5, "type": "dinamica + stretching" },
    "mercoledi": { "duration_min": "10-12", "type": "mobilità pura a casa", "location": "casa" },
    "giovedi":   { "warmup_min": "8-10", "cooldown_min": 5, "type": "dinamica + stretching" },
    "venerdi":   { "warmup_min": "8-10", "cooldown_min": 5, "type": "dinamica + stretching" },
    "sabato":    { "duration_min": "15-20", "type": "flow esteso" },
    "domenica":  { "duration_min": "5-8", "type": "stretching mirato post-corsa (flessori anca, polpacci)" }
  },
  "priority_areas": ["colonna toracica", "spalle", "anche", "caviglie"],
  "note": "Punto di partenza: spalle chiuse e rigidità diffusa. È lavoro strutturale, non riempitivo. Non va mai tagliato per primo."
}
```

### 2.7 Benchmark (settimana 0 e settimana 8)

```json
{
  "benchmarks": [
    { "id": "trazioni",  "test": "Trazioni strict, max reps", "unit": "reps", "baseline_storico": 12 },
    { "id": "panca",     "test": "Panca piana 5RM o 3x8 col massimo carico pulito", "unit": "kg", "baseline_storico": "3x110" },
    { "id": "squat",     "test": "Squat 5RM o 3x8", "unit": "kg", "baseline_storico": "3x100" },
    { "id": "military",  "test": "Military press 3x8", "unit": "kg", "baseline_storico": "3x65" },
    { "id": "corsa",     "test": "Tempo max continuo a 7.5 km/h", "unit": "min", "baseline_attuale": 15 },
    { "id": "mobilita",  "test": "Supino, braccia distese a terra: quanto stacca la lombare", "unit": "cm" },
    { "id": "foto",      "test": "Foto fronte/lato/retro, stessa luce", "unit": "immagine" }
  ],
  "retest_week": 8,
  "note": "L'utente ha scelto di NON usare la bilancia. Questi benchmark sono l'unico metro oggettivo: l'app non deve richiedere né suggerire pesate."
}
```

**Importante per l'app:** non inserire tracking del peso corporeo come campo obbligatorio, non mandare notifiche che invitano a pesarsi, non mostrare grafici di peso vuoti. Il tracking passa da forza, tempi di corsa e foto.

> **Decisione di Fabrizio (24/9/2026):** il modulo Peso di Player One **resta attivo**, in deroga consapevole a questa sezione. Non è un'omissione dell'implementazione.

### 2.8 Nutrizione (unico parametro)

```json
{
  "nutrition": {
    "protein_min_g_per_kg": 2.0,
    "protein_max_g_per_kg": 2.2,
    "example_at_85kg": "170-190 g/giorno",
    "phase": "deficit calorico",
    "note": "In deficit con questo volume, sotto questa soglia il muscolo va via anche con l'allenamento perfetto. È l'unico parametro nutrizionale tracciato."
  }
}
```

---

## 3. Regole logiche da implementare

### 3.1 Doppia progressione

```
PER OGNI esercizio con range di ripetizioni (es. "8-10"):
  SE l'utente completa il TOP del range su TUTTE le serie al RIR target:
    → al prossimo allenamento: aumenta il carico e torna al fondo del range
  ALTRIMENTI:
    → mantieni il carico, punta ad aggiungere ripetizioni
```

Incrementi suggeriti: +2,5 kg sui lower body e sui bilancieri grossi, +1-2 kg su manubri e isolamento.

### 3.2 Deload

```json
{
  "deload": {
    "planned": {
      "week": 6,
      "accessory_volume_reduction_pct": 50,
      "big_lifts": "mantenuti",
      "max_rpe": 7,
      "rationale": "Arrivare al retest della settimana 8 freschi, così i numeri sono veri."
    },
    "autoregulated": {
      "trigger": "2+ settimane consecutive in versione minima",
      "action": "conta come deload già svolto, non aggiungerne un altro subito dopo"
    }
  }
}
```

### 3.3 Trigger versione minima

```json
{
  "minimal_version_triggers": [
    { "id": "sonno",       "condition": "sonno < 5.5h per 3+ notti consecutive" },
    { "id": "sedute_perse","condition": "2 sedute già saltate nella settimana per motivi legati al bambino" },
    { "id": "post_parto",  "condition": "prime 4 settimane dal parto", "automatic": true, "non_negoziabile": true },
    { "id": "rpe_drift",   "condition": "RPE percepito 2+ punti sopra il normale a parità di carico" }
  ],
  "ux_note": "La versione minima NON deve essere presentata come fallimento o downgrade. Nessuna interruzione di streak, nessun badge perso, nessun linguaggio tipo 'hai saltato'. È un piano B legittimo: l'utente ha un profilo tutto-o-niente e il linguaggio dell'app è parte del piano."
}
```

> **Nota di implementazione:** il trigger `sonno` non è automatizzabile — Player One non traccia il sonno. Gli altri tre sono calcolati dall'app.

### 3.4 Versione minima — contenuto

```json
{
  "minimal_version": {
    "sessions_per_week": 4,
    "sessions": [
      { "id": 1, "content": "Full body: SS squat/leg press + rematore · SS panca + curl · plank", "rpe": "6-7" },
      { "id": 2, "content": "Full body: SS RDL + lat machine · SS military + push-down · pallof press", "rpe": "6-7" },
      { "id": 3, "content": "MMA/condizionamento 10' + mobilità", "rpe": "6-7" },
      { "id": 4, "content": "Flessibile: pesi o corsa breve, in base all'energia del giorno", "rpe": "6-7" }
    ],
    "volume": { "gruppi_grandi": "8-10 serie/settimana", "gruppi_piccoli": "4-6 serie/settimana" },
    "mobility": "sempre, minimo 5'",
    "note": "I superset qui sono la chiave: stessa seduta in metà tempo, meno richiesta di energia."
  },
  "plan_c": {
    "trigger": "impossibile raggiungere la palestra",
    "equipment": ["manubri modulabili 2-10 kg x2", "manubrio 18 kg", "corda"],
    "duration_min": "20-25",
    "content": "Full body a casa, stessa logica della versione minima"
  }
}
```

> **Nota di implementazione:** il piano non indica quante serie per esercizio nella versione minima. L'app ne assegna **3**, che portano i gruppi grandi sotto la fascia 8-10 dichiarata sopra. Da rivedere insieme.

### 3.5 Campanello d'allarme (interferenza)

```
SE i carichi sui big lift (squat, panca, stacco rumeno, trazioni) SCENDONO per 3-4 settimane consecutive:
  → il primo taglio è il VOLUME DI CONDIZIONAMENTO
  → NON il cibo, NON il sonno
```

L'app dovrebbe rilevare questo trend automaticamente sui quattro big lift e mostrare l'avviso. È il segnale che l'interferenza tra condizionamento e ipertrofia sta vincendo.

### 3.6 Regole sui superset

```json
{
  "superset_rules": {
    "allowed": "solo antagonisti o muscoli non interferenti",
    "forbidden_on": ["Squat", "Panca piana", "Stacco rumeno", "Trazioni zavorrate", "Rematore bilanciere"],
    "execution": "esercizio A → 10-15\" transizione → esercizio B → 60-75\" recupero → ripeti",
    "fallback": "Se una delle due postazioni è occupata, eseguire come serie normali. Non è un fallimento del piano."
  }
}
```

**Perché gli antagonisti e non gli agonisti:** con muscoli opposti, mentre uno lavora l'altro recupera davvero — non si perde forza né stimolo, si taglia solo il tempo morto. I superset agonisti (stesso muscolo due volte di fila) aumentano la fatica metabolica ma tagliano il carico sulla seconda serie: in deficit calorico costano recupero senza dare stimolo extra.

> **Contraddizione nota nel piano:** il martedì abbina in superset *Push-down tricipiti* e *French press* (stesso muscolo), e il sabato *Curl* + *Estensioni tricipiti* (antagonisti, ok). L'app implementa la scheda come scritta nella sezione 2.2. Il martedì è da sciogliere.

### 3.7 Blocco 2 — ponte dicembre

```json
{
  "block_2": {
    "start": "settimana 9",
    "end": "parto",
    "split": "invariato, 5 giorni",
    "progression": "congelata — stessi carichi, RPE 7 invece di 8",
    "goal": "mantenimento, non crescita",
    "conditioning": "fermo ai livelli della settimana 6; solo la corsa lunga domenicale può crescere",
    "muscle_up": "se non raggiunto entro la settimana 8, in pausa fino a primavera (richiede sistema nervoso fresco)",
    "post_partum": {
      "mode": "versione minima automatica",
      "min_duration_weeks": 4,
      "note": "Non un giorno di meno, anche se ci si sente bene la prima settimana. La prima settimana ci si sente bene: è adrenalina, non recupero."
    }
  }
}
```

---

## 4. Note di allenamento (testi da mostrare in-app)

### Sicurezza MMA
Il sacco misto con calci bassi scarica sullo stinco. **Paratibia obbligatori nelle settimane 1-4**, intensità dei calci al 50% nelle settimane 1-2 e al 70% nelle settimane 3-4. Le ossa dello stinco si adattano molto più lentamente dei muscoli, esattamente come le nocche per i pugni a mani nude.

### Ordine degli esercizi
I big lift vanno sempre a inizio seduta, con recuperi pieni di 2-2,5'. Lo skill muscle-up va prima di tutto il resto il venerdì: la transizione eseguita sotto fatica è il punto in cui ci si fa male alla spalla.

### Perché i fondamentali restano liberi
Squat, panca, stacco rumeno e trazioni zavorrate restano a bilanciere/corpo libero anche nelle giornate stanche. Due motivi: sono i benchmark di forza reale (una leg press non si confronta con uno squat di sei mesi prima) e allenano la stabilizzazione che trasferisce a MMA e muscle-up. Quando si è stanchi si abbassa l'RPE, non si cambia attrezzo. Tutto il resto del piano è già a macchine e cavi.

### Gerarchia dei tagli
Quando la settimana si restringe, l'ordine in cui si taglia è:
1. Corsa lunga della domenica (facoltativa per definizione)
2. Volume accessorio sui pesi
3. Durata dei finisher
4. **Mai la mobilità** — costa poca energia ed è il lavoro strutturale su cui si basa tutto il resto

### Aspettativa realistica post-parto
Con il primo figlio, la versione minima non durerà 3 settimane isolate: realisticamente si vive in minima o vicino per 2-4 mesi. Non è un fallimento del piano né dell'atleta, è fisiologia. L'app non deve trattare questo periodo come un'anomalia da correggere.

---

## 5. Suggerimenti per l'implementazione

Cose che l'app dovrebbe fare, in ordine di utilità:

1. **Switch piena / minima** in evidenza, attivabile in un tap, senza penalità né interruzioni di streak
2. **Timer di recupero** differenziato: 150"/120"/90"/75"/60" secondo l'esercizio, con modalità superset (transizione 15" + recupero 75")
3. **Calcolo automatico del volume** per gruppo muscolare, con confronto rispetto ai target della sezione 2.5
4. **Suggerimento di progressione** secondo la regola della doppia progressione (sezione 3.1), mostrato al momento di inserire il carico
5. **Rilevamento del trend sui big lift** con l'avviso della sezione 3.5
6. **Progressione settimanale automatica** per condizionamento e muscle-up, in base alla settimana corrente del blocco
7. **Checklist mobilità** giornaliera, separata dalla seduta pesi, così non sparisce quando si taglia l'allenamento
8. **Deload automatico alla settimana 6** con riduzione del 50% sugli accessori
9. **Nessun tracking del peso corporeo** — vedi nota nella sezione 2.7
10. **Promemoria proteine** con soglia minima giornaliera (sezione 2.8)

---

*Implementato in Player One il 24 settembre 2026 (`PLAN_ID = 'ibrido-2026-09'`). Le costanti in `index.html` sono la trascrizione di questo file: se cambi il piano, cambia prima qui.*
