---
author: nicosrm
title: Iterative Prisoner's Dilemma
subtitle: Projekt für Evolutionäre Algorithmen
subject: Projektdokumentation
date: 18.07.2024
lang: de-DE
papersize: a4
geometry: margin=3cm
colorlinks: true
bibliography: references.bib
---

# Iterative Prisoner's Dilemma

## Einleitung

Das *Prisoner's Dilemma* (PD) ist ein Gedankenexperiment aus der Spieltheorie,
bei dem es um zwei Agenten geht, die verhaftet und in getrennten, isolierten
Zellen untergebracht werden. Die Staatsanwaltschaft stellt ihnen das sogenannte
*Prisoner's Dilemma* [@kuhn2019]:

> Sie haben die Wahl, zu gestehen [*defect*] oder zu schweigen [*cooperate*].
> Wenn Sie gestehen und Ihr Komplize schweigt, werde ich alle Anklagen gegen Sie
> fallen lassen und Ihre Aussage nutzen, um sicherzustellen, dass Ihr Komplize
> eine schwere Strafe absitzt. Wenn Ihr Komplize gesteht während Sie schweigen,
> kommt er frei, während Sie die Strafe absitzen. Wenn Sie beide gestehen,
> bekomme ich zwei Verurteilungen, aber ich sorge dafür, dass Sie beide
> vorzeitig auf Bewährung entlassen werden. Wenn Sie beide schweigen, muss ich
> mich mit symbolischen Strafen für den Besitz von Schusswaffen begnügen. Wenn
> ihr gestehen wollt, müsst ihr vor meiner Rückkehr morgen früh eine Nachricht
> beim Gefängniswärter hinterlassen [@kuhn2019].

Dies führt zu der folgenden Tabelle [@axelrod1997]:

|               | **Cooperate**  | **Defect**     |
|---------------|:--------------:|:--------------:|
| **Cooperate** | $R = 3, R = 3$ | $S = 0, T = 5$ |
| **Defect**    | $T = 5, S = 0$ | $P = 1, P = 1$ |

Dabei steht $R$ für den *Reward*, den beide für die gemeinsame Kooperation
erhalten, $S$ für den *Sucker's Payoff*, $T$ für die *Temptation to Defect* und
$P$ für die *Punishment* für den gemeinsamen Verrat [@axelrod1997].

Die Agenten befinden sich in dieser Situation in einem Dilemma, in dem ein
Geständnis für jeden von ihnen die bessere Option ist, unabhängig von der
Entscheidung des anderen. Wenn jedoch beide gestehen, ist das Ergebnis für beide
schlechter, als wenn sie beide geschwiegen hätten [@kuhn2019].

Vermeintliche PD-Situationen lassen sich oft besser durch eine iterierte Version
des Spiels darstellen. In diesen iterierten Gefangenendilemmata (*Iterative
Prisoner's Dilemma*, IPD) können die Spieler auf die vorherigen Züge ihres
Gegners reagieren und somit Überläufer bestrafen oder Kooperationen belohnen.
Nun ist die beste Strategie für „rational egoistische Spieler“ nicht mehr
trivial [@kuhn2019]. Daher besteht das Ziel dieses Projekts darin, die 
Generierung neuer Strategien mithilfe evolutionärer Algorithmen zu erforschen.


## Konzept

Als grundlegender Lösungsansatz wurde ein evolutionärer Algorithmus in Anlehnung
an einen Genetischen Algorithmus (GA) implementiert. Der Genotyp der Individuen
bestand dabei aus der sog. *Move Table*. Diese beinhaltet alle möglichen
Situationen, die bei einem IPD auftreten können. Dabei wurde sich auf die drei
letzten Züge beschränkt. Somit entsteht ein Dictionary mit $2^3 = 8$ möglichen
*Keys* – $\{(C,C,C), (C,C,D), (C,D,C), \ldots\}$ (wobei $C$ für *cooperate* und
$D$ für *defect* steht) – als Bedingungen und entsprechend so vielen Aktionen
als *Value*. In der Implementierung wird dies beispielhaft wie folgt
dargestellt.

```swift
let moveTable: [[Move]: Move] = [
    [.C, .C, .C]: .C,
    [.C, .C, .D]: .D,
    // ...
]
```

Die Implementierung des evolutionären Algorithmus soll möglichst
parametrisierbar gestaltet werden, sodass verschiedene Parameter ausgetauscht
werden können. Dies beinhaltet u.a. Rahmenparameter wie die Populationsgröße,
Anzahl der Epochen oder Mutations- und Rekombinationsrate. Außerdem soll die Art
der Selektion, Mutation und Rekombination per CLI-Argument angepasst werden
können.

Konkret wurden zwei verschiedene Selektionsarten implementiert. (1) Eine
$q$-stufige Turnier-Selektion [@weicker2015], wobei das $q$ per CLI-Argument
einstellbar ist. Diese selektiert basierend auf der Anzahl der Siege, die die
Strategien gegen ihre Gegner erzielen konnten. Im Code wird dies durch die
[`TournamentSelection`](https://github.com/nicosrm/24-ea-ipd/blob/main/src/Sources/Selection/TournamentSelection.swift)
repräsentiert. Weiterhin wurde als Ansatz (2) eine fitness-proportionale
Selektion [@weicker2015] basierend auf den Punkten, welche die Individuen gegen
eine Teilmenge von Axelrods Strategien [@axelrod1997] erzielen konnten.
Diese wird im Code als [`EstablishedStrategySelection`
](https://github.com/nicosrm/24-ea-ipd/blob/main/src/Sources/Selection/EstablishedStrategySelection.swift)
geführt.

Es wurden die folgenden *etablierten* Strategien implementiert:

| **Strategie**     | **Kurzbeschreibung**                           |
|-------------------|------------------------------------------------|
| Cooperator        | Kooperiert immer                               |
| Defector          | Verrät immer                                   |
| Random            | Zufälliger Zug                                 |
| Tit For Tat (TFT) | Kooperiert in erster Runde, danach wie Gegner  |
| Suspicious TFT    | Verrät in erster Runde, danach wie Gegner      |
| Tit for Two Tats  | Kooperiert, außer Gegner hat 2x verraten       |

Als Rekombinationen wurde der *One-Point-Crossover* [@weicker2015], sowie der
*Uniform-Crossover* [@weicker2015] implementiert.

Weiterhin wurden die *One-Flip-Mutation* umgesetzt, welche die Aktion für eine
zufällige Bedingung tauscht. Als Alternative kommt die probabilistische Mutation
hinzu, welche für jede Bedingung zufällig die Aktion negiert [@weicker2015].

Der Evolutionsprozess läuft insgesamt wie folgt ab.

```swift
for epoch in 0..<epochCount {
    // Elternselektion
    let selection = select(population.count)

    // ggf. Rekombination + Mutation
    let newPopulation = recombineAndMutate(
        selection.map { $0.strategy }
    )
    
    // Aktualisierung der Population
    population = newPopulation
}

// beste Strategie bestimmen
let best = select(1).first!
```


## Verwendung des Programms

Das o.g. Konzept wurde in der Programmiersprache Swift umgesetzt und kann lokal
oder in einem [Docker](https://www.docker.com/)- bzw.
[Podman](https://podman.io/)-Container gestartet werden. Eine Anleitung zur
Verwendung kann in der `README.md` des 
[Repositories](https://github.com/nicosrm/24-ea-ipd/) unter dem Abschnitt
[Usage](https://github.com/nicosrm/24-ea-ipd/blob/main/README.md#usage)
nachgeschlagen werden.

Beim Start des Programms muss die Mutations- und Rekombinationsrate als
Argumente übergeben werden. Weitere Argumente werden wie folgt standardmäßig
initialisiert.

| Argument               | Standardwert  |
|------------------------|---------------|
| `populationSize`       | $100$         |
| `epochCount`           | $30$          |
| `matchIterationCount`  | $50$          |
| `mutation`             | `one-flip`    |
| `mutationRate`         | ---           |
| `crossover`            | `uniform`     |
| `recombinationRate`    | ---           |
| `selection`            | `established` |
| `tournamentSteps`      | $10$          |

Dabei sei angemerkt, dass `matchIterationCount` beschreibt, wie viele Runden
pro Spiel, d.h. *Strategie vs. Strategie*, gespielt werden sollen. Ferner
bestimmt `tournamentSteps` den Wert von $q$ für die $q$-stufige
Turnier-Selektion.


## Experimente

Die Bewertung für das betrachtete Problem ist nicht trivial. Daher wurde
festgelegt, die folgenden Ansätze zu testen und auszuwerten: (1) die Individuen
treten gegen andere Individuen aus der Population an und (2) die Individuen
treten gegen verschiedene, feste Strategien an. Dies kann im Projekt anhand der
folgenden Varianten umgesetzt werden. Für Variante (1) bietet sich die
implementierte Turnier-Selektion
([`TournamentSelectionSelection`](https://github.com/nicosrm/24-ea-ipd/blob/main/src/Sources/Selection/TournamentSelection.swift))
und für (2) die
[`EstablishedStrategySelection`](https://github.com/nicosrm/24-ea-ipd/blob/main/src/Sources/Selection/EstablishedStrategySelection.swift)
an. Diese wurden im Abschnitt [Konzept](#konzept) bereits erläutert.

Für die Experimente wurden die folgenden Parameter verwendet.

| Argument               | Werte ($^*$ Nicht-Standard)      |
|------------------------|----------------------------------|
| `populationSize`       | $100$                            |
| `epochCount`           | $50^*$ / $200^*$                 |
| `matchIterationCount`  | $100^*$                          |
| `mutation`             | `one-flip`                       |
| `mutationRate`         | $0.02^*$                         |
| `crossover`            | `uniform`                        |
| `recombinationRate`    | $0.7^*$                          |
| `selection`            | `tournament`$^*$ / `established` |
| `tournamentSteps`      | $10$                             |

Dabei ist anzumerken, dass für die Turnier-Selektion ein weitaus geringere
Anzahl an Epochen gewählt wurde. Dies resultierte aus der Tatsache, dass diese
wesentlich mehr Rechenzeit benötigte als Turniere gegen die etablierten
Strategien. Dies begründet sich dadurch, dass im Turnier gegen zehn Strategien
angetreten wird, bei der etablierten Selektion dahingegen nur sechs.

Die Experimente lassen sich mit folgendem Befehl reproduzieren.

```
$ swift run ipd --epoch-count {50 | 200} \
    --match-iteration-count 100 \
    -m 0.02 -r 0.7 \
    --selection {tournament | established}
```


## Ergebnisse

Im folgenden werden die im vorherigen Abschnitt erläuterten Experimente
ausgewertet. Als Metrik wird eine *Defection Rate* $\text{r}_D$
eingeführt, welche das Verhältnis der Defections zu den Gesamt-Aktionen
quantifiziert.

$$\text{r}_D = \frac{\vert\text{defections}\vert}{\vert\text{actions}\vert}$$


### Bewertung anhand etablierter Strategien

In \autoref{auswertung-established} sind die Defection Rates im Verlauf
der Epochen für die Selektion anhand der Bewertung gegen etablierte Strategien
dargestellt. Dabei wurden drei Beispiele exemplarisch herausgesucht – ein
Verlauf, welcher gegen Ende stärker zu Defect tendiert (File 3), ein mittlerer
(File 1) und einer, der zu Cooperate (File 2) tendiert.

![Defection Rate im Verlauf der Epochen gegen etablierte Strategien anhand von
drei ausgewählten Beispielen\label{auswertung-established}](./plot/plot_established.svg)

Dabei ist zu erkennen, dass die Defection Rate stark oszilliert und sich, bis
auf einige Ausreißer, meist in der Nähe von $0.5\pm 0.2$ bewegt. File 3
steigt in den letzten Epochen stark an. Allerdings ist hier nicht klar, ob dies
einen Trend oder einen weiteren Ausreißer darstellt. File 1 und 2 setzen ihre
Oszillation über den gesamten Verlauf fort und verlassen zum Ende nicht den o.g.
Bereich.

Die resultierenden Regeln sind dabei im folgenden dargestellt. Dabei sind die
Listen in der ersten Spalte als Bedingung und der rechte Buchstabe als Aktion zu
verstehen. Beispielweise ist die Regel mit der Bedingung $(C, C, D)$ und Aktion
$D$ wie folgt zu interpretieren: wenn der Gegner zunächst zwei mal kooperiert
$(C)$ und einmal verraten $(D)$ hat, folgt die Aktion Defect $(D)$.

| Bedingung    | File 1  | File 2  |  File 3 | Tit for Tat |
|--------------|:-------:|:-------:|:-------:|:-----------:|
| $(C, C, C)$  | $C$     | $C$     | $D$     | $C$         |
| $(C, C, D)$  | $D$     | $C$     | $D$     | $D$         |
| $(C, D, C)$  | $C$     | $C$     | $D$     | $C$         |
| $(C, D, D)$  | $D$     | $C$     | $D$     | $D$         |
| $(D, C, C)$  | $C$     | $C$     | $C$     | $C$         |
| $(D, C, D)$  | $D$     | $D$     | $D$     | $D$         |
| $(D, D, C)$  | $C$     | $D$     | $D$     | $C$         |
| $(D, D, D)$  | $C$     | $D$     | $D$     | $D$         |
|              |         |         |         |             |
| $\text{r}_D$ | $0.375$ | $0.375$ | $0.875$ | $0.5$       |

Dabei ist zu erkennen, dass die evolvierte Strategie aus File 1 nahezu der
*Tit-for-Tat*-Strategie (siehe Abschnitt [Konzept](#konzept)) entspricht.
Ausschließlich die letzte Regel zur Bedingung $(D,D,D)$ weicht ab, in dem
kooperiert statt verraten wird. Im Ergebnis von File 2 ist ohne Weiteres keine
direkte Logik erkennbar. Das Ergebnis von File 3 dagegen ist entspricht fast der
*Defect*-Strategie bis auf eine Aktion. Es ist durchaus denkbar, dass die
evolvierten Strategien im weiteren Verlauf irgendwann den angesprochenen
Strategien entsprechen. Allerdings könnte es auch sein, dass diese weiterhin
oszillieren und die hier eingefangene Momentaufnahme tatsächlich nur denjenigen
Moment darstellt.


### Bewertung anhand der eigenen Population

Den Verlauf der Defection Rate für die Turnier-Selektion, d.h. der Bewertung
anhand der Siege des Individuums gegen andere Individuen aus der Population,
ist in \autoref{auswertung-turnier} zu sehen.

![Defection Rate im Verlauf der Epochen mit Turnier-Selektion
\label{auswertung-turnier}](./plot/plot_tournament.svg)

Dabei ist zu erkennen, dass die Kurve weniger stark oszilliert als jene im
vorherigen Kapitel. Außerdem liegt der Verlauf meist über $0.5$, d.h. es gibt
stets mehr Verrate als Kooperationen in der besten Strategie der jeweiligen
Epoche. Interessant ist der Ausschlag in der 47. Epoche, bei dem die Defection
Rate bei $1.0$ liegt, hier also die *Defector*-Strategie angenommen wird. Bei
der Betrachtung der schlussendlich finalen evolvierten Strategie (siehe folgende
Tabelle) wird allerdings erkenntlich, dass diese zugunsten der annähernden
*Tit-for-Tat*-Strategie aufgegeben wird.

| Bedingung    | File 1  | Tit for Tat |
|--------------|:-------:|:-----------:|
| $(C, C, C)$  | $C$     | $C$         |
| $(C, C, D)$  | $D$     | $D$         |
| $(C, D, C)$  | $C$     | $C$         |
| $(C, D, D)$  | $D$     | $D$         |
| $(D, C, C)$  | $C$     | $C$         |
| $(D, C, D)$  | $D$     | $D$         |
| $(D, D, C)$  | $C$     | $C$         |
| $(D, D, D)$  | $C$     | $D$         |
|              |         |             |
| $\text{r}_D$ | $0.375$ | $0.5$       |

Weiterhin ist es faszinierend – wenn auch der probabilistischen Natur des
Evolutionsprozesses geschuldet –, dass die Strategie der evolvierten Strategie
aus der etablierten Selektion in File 1 entspricht.

### Kritik

In diesem Unterabschnitt sollen Verbesserungsvorschläge zu der aktuellen
Implementierung und den Experimenten gesammelt werden. Diese dienen als
*Lessons Learned* bzw. als Ansatzpunkte für zukünftige Arbeiten auf diesem
Gebiet.

Ein Kritikpunkt stellt die Bewertung der beiden Selektionen dar. Die Idee, beide
Systeme zu vergleichen war interessant, v.a. weil zwei verschiedene Ansätze
miteinander konkurrieren. Einerseits die Bewertung anhand von Spielen
gegen zufällig ausgewählte Individuen aus der aktuellen Population und
andererseits gegen etablierte, festgelegte Strategien.

Um die Vergleichbarkeit zu verbessern, wäre es allerdings vorteilhaft,
so wenig Parameter wie möglich zu verändern. Somit ergeben sich mehrere
Verbesserungsideen.

Andererseits könnte man die Anzahl der Gegner in der Turnier-Selektion
gleichsetzen mit der Anzahl der Gegner bei der etablierten Selektion. Da
insgesamt sechs verschiedene etablierte Strategien implementiert sind, wäre dies
erreichbar gewesen, in dem der `tournamentSteps`-Parameter ebenfalls auf sechs
gesetzt worden wäre.

Weiterhin hätte man die etablierte Selektion anders aufbauen können. In der
aktuellen Implementierung basiert die Fitness auf der Summe der Punkte, die die
Individuen gegen die etablierten Strategien gesammelt haben. Diese bildete die
Basis für eine fitness-proportionale Selektion [@weicker2015]. Um weniger 
Parameter zu verändern, könnte die Selektion ebenfalls als Turnier-Selektion
umgesetzt werden. Dabei stellen die Gegner allerdings nicht Individuen aus der
Population dar, sondern ebenjene etablierte Strategien.

Ein weiterer Verbesserungsvorschlag bezieht sich auf die verwendete
Fitnessmetrik bei der Turnier-Selektion. Diese basiert nicht wie bei der
etablierten Selektion auf Punkten, welche in den Spielen gegen andere Strategien
erworben wurden. Vielmehr besteht diese lediglich aus der Anzahl der Siege,
welches das jeweilige Individuum im Turnier erringen konnte. Somit werden
verschiedene Individuen auf denselben Fitness-Wert abgebildet, wodurch bei der
Besten-Selektion [@weicker2015] ggf. nicht das beste Individuum bzgl. der
erreichten Punktzahl gewählt wird.


## Fazit

Im Rahmen dieses Projektes wurde ein parametrisierbarer, evolutionärer
Algorithmus zur Findung von Strategien für das *Iterated Prisoner's Delimma*
konzipiert, implementiert und getestet. Dabei wurden zwei verschiedene Ansätze
zur Bewertung und Selektion betrachtet und entsprechende Verbesserungsvorschläge
erörtert.

Dafür wurde der zu findende Regelsatz als Genotyp verwendet und einem
Evolutionsprozess unterzogen. Dieser bestand aus einer Elternselektion, für
welche im Rahmen dieses Projektes zwei verschiedene Bewertungsansätze untersucht
wurden. Die selektierten Eltern wurden anschließend nach einer bestimmten
Wahrscheinlichkeit rekombiniert und schließlich mutiert. Die resultierenden
Individuen bildeten die neue Population.

Durch diesen Generationenzyklus wurden verschiedene Strategien generiert. Zwei
exemplarisch ausgewählte entsprachen nahezu der etablierten
*Tit-for-Tat*-Strategie, eine andere der möglicherweise als naiv betrachtbaren
*Defector*-Strategie [@kuhn2019]. Somit konnten Strategien evolviert werden,
welche im alltäglichen, gesellschaftlichen Leben beobachtbar sind: zum einen die
bekannte „Wie du mir, so ich dir“-Strategie und zum anderen eine egoistische
Strategie, welche stets verrät, um sich selbst in eine bessere Situation zu
bringen.


## Literatur

::: {#refs}
:::
