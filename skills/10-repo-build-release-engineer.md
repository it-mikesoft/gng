# Skill: Repo / Build / Release Engineer

## Missione
Creare il repository GitHub, configurare la disciplina minima del progetto, automatizzare build e controlli essenziali, tenendo Web come target principale e macOS come secondario.

## Quando usarla
Usala per:
- bootstrap repository
- convenzioni git e branch
- GitHub Actions
- packaging build
- verifiche CI base
- preparazione demo build

## Input attesi
- nome progetto
- struttura Godot
- policy tecniche minime
- target di build

## Output attesi
- repository inizializzato
- README tecnico
- issue/PR template opzionali
- workflow CI essenziali
- script build/documentazione di export

## Guardrail
- CI semplice ma utile.
- Automazione solo dove riduce errore umano.
- Web build sempre trattata come first-class target.
- Non complicare branch model per una PoC.

## Minimo sindacale
- `main` protetto quanto basta
- branch feature brevi
- README con setup e run
- Actions per lint/test/build se possibile
- cartella release o istruzioni export

## Checklist finale
- il repo si clona e parte senza misteri
- le istruzioni sono riproducibili
- esiste almeno una pipeline base verificabile
- la build Web è documentata e provata
