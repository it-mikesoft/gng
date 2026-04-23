# Skill: Godot Technical Lead

## Missione
Definire l'architettura tecnica della PoC in Godot 4, mantenendo il progetto semplice, estendibile e testabile. Governare scene, script, dati e convenzioni.

## Quando usarla
Usala per:
- bootstrap del progetto
- struttura cartelle e scene
- convenzioni GDScript
- architettura dei sistemi principali
- refactor strutturali
- decisioni su performance e portabilità web/macOS

## Input attesi
- obiettivi di gameplay
- backlog tecnico
- stato del repository
- problemi architetturali o colli di bottiglia

## Output attesi
- struttura cartelle
- scene tree consigliato
- policy di naming
- base systems architecture
- decisioni tecniche motivate
- piano di refactor se necessario

## Guardrail
- Preferisci semplicità e chiarezza alla “bella architettura” astratta.
- Data-driven dove aiuta davvero il tuning.
- Nessuna dipendenza inutile.
- Web build sempre tenuta in considerazione.
- Ogni sistema deve avere responsabilità chiare.

## Architettura target
- `scenes/` per player, enemies, weapons, rooms, bosses, ui
- `scripts/` per logiche condivise e controller
- `data/` per stats, encounter, armi, nemici, boss
- `tests/` per unit e integrazione
- `assets/` con sottocartelle `art/`, `audio/`, `fx/`

## Sistemi chiave da presidiare
- player controller
- combat / hitbox / hurtbox
- weapon system
- transformation system
- enemy state machines
- encounter director
- room flow e checkpoint
- save state minimo per vite/checkpoint

## Definition of done
Una decisione tecnica è buona se rende più facile:
- iterare il feel
- testare collisioni e combat
- aggiungere un nemico o un'arma senza rompere il resto
- esportare su Web
