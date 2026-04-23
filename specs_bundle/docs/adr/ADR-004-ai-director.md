# ADR-004: AI Director

## Status
Accepted

## Context
Si vuole inserire una componente AI senza compromettere la leggibilità, la fairness e il controllo del level design.

## Decision
Implementare un Director parametrico con tre responsabilità principali:
- anti-stallo
- modulazione dell'intensità
- variazione controllata degli encounter

## Vincoli
- nessun machine learning runtime
- nessuna generazione casuale incontrollata
- nessuno spawn inevitabile o scorretto
- ogni morte deve essere spiegabile dal giocatore

## Input osservati
- tempo fermo del giocatore
- danni recenti subiti
- avanzamento nel livello
- vite residue
- ritmo di eliminazione nemici

## Output consentiti
- scelta di micro-varianti di spawn
- aumento o riduzione controllata della pressione
- attivazione di nemici anti-stallo
- riordino leggero del pacing

## Consequences

### Positive
- Rigiocabilità
- Maggiore tensione
- Mondo meno statico

### Negative
- Tuning manuale necessario
- Rischio di frustrazione se i limiti non sono rigorosi
