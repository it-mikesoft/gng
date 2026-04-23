# ADR-001: Engine e Stack Tecnologico

## Status
Accepted

## Context
È necessario scegliere uno stack per sviluppare una PoC di un platform 2D ispirato allo spirito di Ghosts 'n Goblins, con forte enfasi su rapidità di sviluppo, controllo del gameplay, deploy web e testabilità.

## Decision
Utilizzare:
- Godot 4
- Linguaggio: GDScript
- Repository: GitHub
- CI/CD: GitHub Actions
- Target primario: Web
- Target secondario: macOS

## Consequences

### Positive
- Rapidità di prototipazione
- Ottimo supporto per 2D
- Facile esportazione Web
- Basso overhead tecnico
- Architettura semplice da comprendere per Claude Code

### Negative
- Possibili limiti di performance e memoria sul target Web
- Alcune librerie e plugin hanno un ecosistema più ridotto rispetto a Unity

## Alternatives Considered
- Unity: scartato per maggiore complessità e overhead iniziale
- Unreal: scartato per eccesso di peso rispetto a una PoC 2D

## Notes
Il target di sviluppo deve restare compatibile con una PoC giocabile, finibile, mantenibile e facile da condividere via browser.
