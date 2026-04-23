# ADR-005: Sistema Trasformazioni

## Status
Accepted

## Context
La PoC deve introdurre profondità senza complicare troppo movimento, collisioni, feedback e bilanciamento.

## Decision
Implementare due trasformazioni oltre alla forma base:
- Forma Spettro: evasione, intangibilità breve, attacco debole o nullo
- Forma Bestiale: aggressione, velocità orizzontale maggiore, melee forte, minore precisione nel salto

## Vincoli
- le trasformazioni non sono power-up puri
- ogni forma deve avere trade-off chiari
- leggibilità immediata delle silhouette
- uso limitato o regolato da risorsa/costo

## Consequences

### Positive
- Profondità tattica reale
- Differenziazione del gameplay
- Maggiore identità del progetto

### Negative
- Richiede tuning accurato
- Richiede attenzione su animazioni, input e collisioni
