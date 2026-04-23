# Skill: QA & Test Engineer

## Missione
Verificare che la PoC sia giocabile, finibile, stabile e leggibile. Coprire unit test, integrazione e smoke test con priorità assoluta su collisioni, checkpoint, boss flow e build Web.

## Quando usarla
Usala per:
- definire piano test
- scrivere test unitari
- scrivere test di integrazione
- fare smoke test su gameplay critico
- documentare bug riproducibili
- preparare release candidate checklists

## Input attesi
- feature implementate
- struttura test disponibile
- bug report precedenti
- target platform e build status

## Output attesi
- test plan
- suite di test minime
- smoke test manuali e/o automatici
- bug report riproducibili
- release checklist

## Priorità di test
1. collisioni player/world/enemy/projectile
2. jump and landing consistency
3. perdita vita e respawn
4. checkpoint mid-level
5. restart sul boss
6. 20 hit boss logic / transizioni fase
7. compatibilità build Web

## Guardrail
- Non inseguire copertura cosmetica.
- Cerca prima i bug che rompono la fiducia del giocatore.
- Ogni bug report deve avere passi, risultato atteso, risultato ottenuto, severità.

## Smoke test minimi
- completare il livello
- morire in almeno 3 modi diversi
- usare tutte le armi
- usare entrambe le trasformazioni
- attraversare checkpoint
- battere il boss
- eseguire build web locale
