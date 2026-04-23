# GNG PoC Repo Starter

Repository starter per una PoC di action platform 2D gotico ispirato allo spirito di Ghosts 'n Goblins.

## Obiettivo
Realizzare una PoC finibile e usabile via Web con:
- 1 livello completo
- 1 boss finale a 2 fasi
- 3 vite
- 5 armi
- 2 trasformazioni
- 4 tipi di nemici
- AI Director leggero
- audio e grafica AI-assisted ma coerenti

## Struttura
- `docs/`: documenti decisionali, requisiti, prompt e QA
- `assets/`: asset raw, candidati e approvati
- `game/`: progetto Godot
- `tools/`: script di supporto
- `claude/`: brief, checklist e handoff per Claude Code

## Regole
1. Nessun asset raw entra direttamente in `game/`
2. Claude Code legge prima `docs/adr` e `docs/bdr`
3. Gli asset devono passare la checklist QA prima di diventare approved
4. Il target primario è Web
