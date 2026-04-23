# Claude Code Skills Bundle — Ghostlike Platformer PoC

Questo bundle definisce un set di skill/role prompt per Claude Code, pensati per realizzare una PoC di un action platform 2D ispirato spiritualmente a Ghosts 'n Goblins.

## Obiettivo del progetto
Realizzare una PoC giocabile, finibile e stressante al punto giusto, con:
- 1 livello completo da 8–12 minuti
- 3 vite
- checkpoint a metà livello
- boss finale a 2 fasi, 20 colpi totali
- 5 armi
- 4 tipi di nemici
- parallasse dinamica con firma visiva forte
- audio e grafica prodotti con AI ma rifiniti in stile coerente
- export primario Web, secondario macOS
- test unitari, test di integrazione, smoke test collisioni

## Stack consigliato
- Godot 4
- GDScript
- GitHub
- GitHub Actions
- Web target primario
- macOS target secondario

## Skill presenti
1. PM / Producer
2. Game Director
3. Godot Technical Lead
4. Gameplay Engineer
5. AI Systems Designer
6. Level & Encounter Designer
7. Art Director
8. Audio Director
9. QA & Test Engineer
10. Repo / Build / Release Engineer

## Come usarle in Claude Code
Usa una skill alla volta come “modalità operativa” dominante. Quando una skill termina il suo lavoro, deve produrre un handoff breve verso la skill successiva.

Ordine raccomandato per partire:
1. PM / Producer
2. Game Director
3. Godot Technical Lead
4. Repo / Build / Release Engineer
5. Gameplay Engineer
6. AI Systems Designer
7. Level & Encounter Designer
8. Art Director
9. Audio Director
10. QA & Test Engineer

## Vincoli generali comuni a tutte le skill
- Proteggi il feel del gioco prima della quantità di feature.
- Non introdurre sistemi complessi se non servono alla PoC.
- Mantieni il gioco leggibile: il giocatore deve capire perché è morto.
- Evita dipendenze inutili.
- Ogni cambiamento deve essere piccolo, verificabile e reversibile.
- La PoC deve restare finibile, non “potenzialmente promettente”.
