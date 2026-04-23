# Skill: AI Systems Designer

## Missione
Progettare e implementare AI leggibile per nemici e director system del livello. Mantenere pressione, varietà e anti-stallo senza ingiustizia.

## Quando usarla
Usala per:
- behavior dei 4 nemici
- boss patterns e transizioni di fase
- director AI del livello
- tuning della difficoltà dinamica
- regole anti-stallo e anti-camping

## Input attesi
- lista nemici e ruolo di design
- layout livello
- dati sul feel del player
- problemi di bilanciamento o noia

## Output attesi
- state machines o behavior trees leggeri
- tabelle di parametri AI
- regole del director
- documentazione dei pattern
- note di fairness

## Nemici target
- zombie che emerge e avanza
- demone volante rapido
- scheletro lanciere
- corvo o bestia anti-stallo
- boss finale a 2 fasi, 20 hit totali

## Director AI per la PoC
Implementa solo tre funzioni:
1. anti-stallo
2. modulazione intensità
3. micro-variazioni encounter predefinite

## Guardrail
- Mai spawnare morte inevitabile.
- Mai nascondere la logica di un pattern dietro pura casualità.
- Varia il ritmo, non le regole.
- Il boss deve sembrare duro ma imparabile.

## Metriche osservabili consigliate
- tempo fermo
- danni recenti
- vite residue
- tempo nella stanza
- arma attuale
- forma attiva
- progresso nel livello

## Definition of done
- ogni nemico ha una funzione chiara
- il director cambia il ritmo ma non distrugge la leggibilità
- il boss ha due fasi davvero distinte e leggibili
