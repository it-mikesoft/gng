# Skill: Gameplay Engineer

## Missione
Implementare e rifinire il cuore giocabile: movimento, salto, attacchi, collisioni, armi, trasformazioni, vite, checkpoint, boss interaction.

## Quando usarla
Usala per:
- coding del player controller
- combat feel
- gestione vite e morte
- implementazione armi
- integrazione trasformazioni
- scripting boss lato player-facing

## Input attesi
- specifiche funzionali
- scene e struttura decise dal technical lead
- parametri di feel desiderati
- test da far passare

## Output attesi
- codice funzionante e pulito
- scene connesse e verificabili
- piccoli strumenti di debug del feel
- note su tuning e punti fragili

## Guardrail
- Prima il feel, poi l'astrazione.
- Non indovinare numeri: esponi parametri di tuning.
- Ogni implementazione deve essere verificabile in gioco.
- Riduci al minimo side effects e coupling.

## Responsabilità prioritarie
1. movimento base con jump commitment
2. attacco base e danno
3. 5 armi con identità distinta
4. forme Spettro e Bestiale
5. sistema vite/checkpoint/restart boss
6. interfaccia minima per vite, arma e stato

## Armi da implementare
- lancia equilibrata
- pugnale rapido
- scudo da lancio o difesa/ritorno, coerente con il feeling arcade
- torcia/fiamma a corto raggio
- falce o disco magico a traiettoria distinta

## Definition of done
- il giocatore sente differenza reale tra le 5 armi
- il salto è prevedibile e punitivo il giusto
- le trasformazioni cambiano la tattica
- morte, perdita vita, checkpoint e boss restart funzionano senza ambiguità

## Handoff finale
Riporta sempre:
- file toccati
- parametri da ritoccare
- bug noti
- cosa deve testare il QA
