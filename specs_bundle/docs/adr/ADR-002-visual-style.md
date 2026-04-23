# ADR-002: Stile Visivo

## Status
Accepted

## Context
Il progetto deve evocare chiaramente Ghosts 'n Goblins senza diventare copia diretta, mantenendo una resa moderna ma leggibile e adatta al gameplay.

## Decision
Adottare uno stile:
- pixel-art HD o ibrido pixel-illustrato
- palette limitata
- forte contrasto foreground/background
- silhouette leggibili in meno di un secondo
- animazioni teatrali, leggibili, non realistiche
- parallasse dinamica con una firma visiva forte

### Firma visiva forte della PoC
- luna piena dominante
- castello gotico lontano
- alberi secchi e rovine
- nebbia leggera
- profondità atmosferica, non fotorealistica

## Vincoli
- no fotorealismo
- no eccesso di dettaglio
- no motion blur
- no effetti che nascondono hitbox, proiettili o collisioni

## Consequences

### Positive
- Alta leggibilità del gameplay
- Coerenza estetica
- Forte identità visiva
- Facilità di validazione degli asset AI

### Negative
- Richiede disciplina stilistica costante
- Gli asset AI devono essere normalizzati e resi coerenti

## Alternatives
- 2.5D realistico: scartato
- cartoon moderno saturo: scartato
