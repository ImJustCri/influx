# Influx

![Tema](https://img.shields.io/badge/tema-dark-0D1230?style=flat-square)
![Piattaforma](https://img.shields.io/badge/piattaforma-iOS%20%7C%20Android-2E9C4A?style=flat-square)
![Stato](https://img.shields.io/badge/stato-in%20sviluppo-FBBF24?style=flat-square)

>[!note]
Branch dedicata all'implementazione del design system

**Influx** è un'app di finanza personale che ti aiuta a monitorare le spese, capire la tua inflazione reale e trovare alternative più economiche o sostenibili ai prodotti che compri già.

---

## Funzionalità

### 🧾 Scanner scontrini
Inquadra qualsiasi scontrino cartaceo o digitale con la fotocamera. L'app legge, categorizza e registra ogni voce automaticamente — nessun inserimento manuale.

### 📊 Monitoraggio spese
Tieni sotto controllo le tue uscite per categoria: alimentari, carburante, abbigliamento, farmaci, elettronica, abbonamenti online e altro. Visualizza l'andamento nel tempo e confronta i mesi tra loro.

### 📈 Inflazione personale
L'inflazione che ti riguarda non è quella media nazionale. Influx calcola il tuo tasso reale basandosi su quello che compri tu — e ti mostra esattamente quali categorie ti stanno costando di più.

### 🌿 ecoSwitch
La funzione principale dell'app. ecoSwitch ti suggerisce alternative più economiche o più ecosostenibili ai prodotti che acquisti abitualmente. Swipe a destra per accettare un suggerimento, a sinistra per saltarlo. Tieni traccia di quanto hai risparmiato e del tuo eco score personale.

Modalità disponibili:
- **Risparmio** — priorità al prezzo più basso
- **Eco-sostenibile** — priorità a prodotti bio, locali, packaging riciclabile
- **Entrambi** — il miglior equilibrio tra costo e sostenibilità
---

### Group mode
Crea un gruppo condiviso con amici (per viaggi, per esempio) o con la famiglia. Ognuno aggiunge le proprie spese, e tutti vedono una dashboard unificata con il budget comune, i movimenti recenti e l'eco score del gruppo.

## Note

Questa repository contiene **solo il client Flutter**. Il backend non è incluso.

---

## Installazione

```bash
# Clona il repository
git clone https://github.com/tuousername/influx.git

# Entra nella cartella
cd influx

# Installa le dipendenze
flutter pub get

# Avvia in sviluppo
flutter run
```

---

## Licenza

[MIT](LICENSE)
