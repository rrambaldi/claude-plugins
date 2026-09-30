---
name: nemo-iudex-in-causa-sua
description: Fa rivedere un diff da un subagente che non l'ha scritto e riceve solo il task e il diff, non la conversazione, poi verifica i rilievi e corregge quelli veri. Attivala SEMPRE quando l'utente scrive "Nemo iudex in causa sua" o la sigla "-NIICS" (con o senza slash, in qualunque combinazione di maiuscole, da soli o seguiti da un commit, un intervallo come HEAD~3.. o una PR), oppure chiede una revisione indipendente, per esempio "fai rivedere il diff a qualcun altro", "code review con occhi nuovi", "rivedi le modifiche da zero". Attivala anche da sola prima di dire finito un task di codice il cui diff supera le 50 righe o i 3 file, o tocca soldi, dati o sicurezza. Non usarla per diff di poche righe, per modifiche solo alla documentazione né per rivedere idee o testi (per quelli c'è limam-adhibere).
---

# Nemo iudex in causa sua

"Nessuno è giudice nella propria causa". Comando: `Nemo iudex in causa sua` o `-NIICS`, come
parola a sé.

Chi ha scritto il codice lo rilegge con le stesse assunzioni con cui l'ha scritto, e non vede
proprio ciò che ha dato per scontato. Qui la revisione la fa un subagente che non l'ha scritto:
riceve il task e il diff, non la conversazione né il perché delle scelte. Se glielo dici, lo
convinci invece di farti controllare.

## Quando

- **Con il comando.** Da solo rivede le modifiche non committate. Seguito da un commit, un
  intervallo (`HEAD~3..`), un branch (contro quello principale) o una PR (`gh pr diff`), rivede
  quello.
- **Da sola**, prima di dire finito un task di codice il cui diff supera le 50 righe o i 3 file, o
  tocca soldi, dati o sicurezza (autenticazione, permessi, migrazioni, pagamenti). Non per diff di
  poche righe, solo documentazione, o se l'utente ha detto di non farlo.

## Passi

### 1. Scrivi il task

Cosa ha chiesto l'utente, con le sue parole, e i vincoli che ha dato. Per un commit o una PR che
non vengono da questa conversazione, il task è il messaggio del commit o la descrizione della PR.

Non scrivere come l'hai fatto, cosa hai scartato e perché: sono proprio le assunzioni da mettere
alla prova.

### 2. Lancia il subagente

Un subagente nuovo, di uso generale, con il modello più forte che hai. Mai un fork: eredita la
conversazione, cioè le assunzioni che non deve avere. Il prompt, riempito:

```
Rivedi un diff che non hai scritto. Non modificare niente: leggi e rispondi.

Task chiesto dall'utente: «[il task del passo 1]»
Repo: [percorso]. Il diff: [comando: git diff HEAD, più i file nuovi di git ls-files --others
--exclude-standard; oppure git show SHA, git diff A..B, gh pr diff N].
Leggi pure tutto il repo per il contesto: chiamanti, test, convenzioni.

Cerca, in quest'ordine:
1. Cosa il task chiede e il diff non fa, o fa a metà.
2. Cosa il diff fa e il task non chiede: righe o file estranei, refactor non richiesti, file di
   prova dimenticati.
3. Cosa si rompe: chiamanti non aggiornati, casi limite, errori ingoiati, test che mancano o che
   passerebbero anche con il codice sbagliato.
4. Sicurezza: segreti, input non validato, permessi.

Per ogni problema: file:riga, cosa succede e con quale input o stato. Solo problemi che puoi
mostrare, niente gusti di stile. Al massimo 10 punti, dal più grave. Se non trovi niente, dillo:
una revisione vuota va bene.
```

Se non puoi lanciare subagenti, dillo in una riga e fai la revisione tu con la stessa lista,
dichiarandola non indipendente.

### 3. Verifica i rilievi

Il revisore non ha il contesto e può sbagliare. Controlla ogni rilievo nel codice prima di
toccare qualcosa:

- **vero**: correggilo, dentro il perimetro del task;
- **falso**: scartalo, con una riga che dice perché (il fatto, non "non sono d'accordo");
- **vero ma fuori dal task**: segnalalo, non correggerlo.

Se le correzioni non sono banali, un secondo giro solo su di loro. Al massimo uno: poi decidi tu.

### 4. Report

In poche righe: quanti rilievi, quali corretti, quali scartati e perché, quali segnalati. Se la
revisione è partita da sola, basta una riga dentro il resoconto del task.
