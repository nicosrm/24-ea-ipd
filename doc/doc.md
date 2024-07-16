---
author: nicosrm
title: Iterative Prisoner's Dilemma
subtitle: Projekt für Evolutionäre Algorithmen
subject: Projektdokumentation
institution: Hochschule für Technik, Wirtschaft und Kultur Leipzig
date: 18.07.2024
lang: de-DE
papersize: a4
boxlinks: true
---

# Iterative Prisoner's Dilemma

## Einleitung

Das *Prisoner's Dilemma* (PD) ist ein Gedankenexperiment aus der Spieltheorie,
bei dem es um zwei Agenten geht, die verhaftet und in getrennten, isolierten
Zellen untergracht werden. Die Staatsanwaltschaft bietet ihnen das sogenannte
*Prisoner's Dilemma* an (Kuhn, 2019):

> Sie haben die Wahl, zu gestehen oder zu schweigen. Wenn Sie gestehen und Ihr
> Komplize schweigt, werde ich alle Anklagen gegen Sie fallen lassen und Ihre
> Aussage nutzen, um sicherzustellen, dass Ihr Komplize eine schwere Strafe
> absitzt. Wenn Ihr Komplize gesteht, während Sie schweigen, kommt er frei,
> während Sie die Strafe absitzen. Wenn Sie beide gestehen, bekomme ich zwei
> Verurteilungen, aber ich sorge dafür, dass Sie beide vorzeitig auf Bewährung 
> entlassen werden. Wenn Sie beide schweigen, muss ich mich mit symbolischen
> Strafen für den Besitz von Schusswaffen begnügen. Wenn ihr gestehen wollt,
> müsst ihr vor meiner Rückkehr morgen früh eine Nachricht beim Gefängniswärter 
> hinterlassen (Kuhn, 2019).

Dies führt zu der folgenden Tabelle (Axelrod, 1997):

|               | **Cooperate**  | **Defect**     |
|---------------|:--------------:|:--------------:|
| **Cooperate** | $R = 3, R = 3$ | $S = 0, T = 5$ |
| **Defect**    | $T = 5, S = 0$ | $P = 1, P = 1$ |

Dabei steht $R$ für den *Reward*, den beide für die gemeinsame Kooperation
erhalten, $S$ für den *Sucker's Payoff*, $T$ für die *Temptation to Defect* und
$P$ für die *Punishment* für den gemeinsamen Verrat (Axelrod, 1997).

Die Gefangenen befinden sich in dieser Situation in einem Dilemma, in dem ein
Geständnis für jeden von ihnen die bessere Option ist, unabhängig von der
Entscheidung des anderen. Wenn jedoch beide gestehen, ist das Ergebnis für beide
schlechter, als wenn sie beide geschwiegen hätten (Kuhn, 2019).

Vermeintliche PD-Situationen lassen sich oft besser durch eine iterierte Version
des Spiels darstellen. In diesen iterierten Gefangenendilemmata (*Iterative
Prisoner's Dilemma*, IPD) können die Spieler auf die vorherigen Züge ihres
Gegners reagieren und somit Überläufer bestrafen oder Kooperationen belohnen.
Nun ist die beste Strategie für „rational egoistische Spieler“ nicht mehr
trivial (Kuhn, 2019). Daher besteht das Ziel dieses Projekts darin, die 
Generierung neuer Strategien mithilfe evolutionärer Algorithmen zu erforschen.


## Konzept

Als grundlegender Lösungsansatz wurde ein evolutionärer Algorithmus in Anlehnung
an einen Genetischen Algorithmus (GA) implementiert. Der Genotyp der Individuen
bestand dabei aus der sog. *Move Table*. Diese beinhaltet alle möglichen
Situation, die bei einem IPD auftreten kann. Es wurde sich hierbei auf die
drei letzten Züge beschränkt. Somit entsteht ein Dictionary mit $2^3 = 8$
möglichen *Keys* – $\{(C,C,C), (C,C,D), (C,D,C), \ldots\}$ (mit $C$ für
*cooperate* und $D$ für *defect*) – als Bedingungen und entsprechend so viele
Aktionen als *Value*. In der Implementierung sieht das beispielhaft wie folgt
aus.

```swift
let moveTable: [[Move]: Move] = [
    [.C, .C, .C]: .C,
    [.C, .C, .D]: .D,
    // ...
]
```

Die Implementierung des evolutionären Algorithmus soll möglichst modular
gestaltet werden, sodass verschiedene Parameter ausgetauscht werden können. Dies
beinhaltet u.a. Rahmenparameter wie die Populationsgröße, Anzahl der Epochen
oder Mutations- und Rekombinationsrate. Außerdem soll die Art der Selektion, der
Mutation und der Rekombination per CLI-Argument angepasst werden können.

Konkret wurden zwei verschiedene Selektionsarten implementiert. (1) Eine
$q$-stufige Turnierselektion, wobei das $q$ per CLI-Argument einstellbar ist.
Diese selektiert basierend auf den Gewinnen, die die Strategien gegen ihre
Gegner erzielen konnten. (2) Eine fitness-proportionale Selektion basierend auf
den Punkten, den die Individuen gegen eine Teilmenge von Axelrod's Strategien
(Axelrod, 1997) erzielen konnten. Letztere wird im Code
als `EstablishedStrategySelection` geführt.

Es wurden die folgenden *etablierten* Strategien implementiert:

| **Strategie**     | **Kurzbeschreibung**                           |
|-------------------|------------------------------------------------|
| Cooperator        | Kooperiert immer                               |
| Defector          | Verrät immer                                   |
| Random            | Zufälliger Zug                                 |
| Tit For Tat (TFT) | Kooperieren in erster Runde, danach wie Gegner |
| Suspicious TFT    | Verraten in erster Runde, danach wie Gegner    |
| Tit for Two Tats  | Kooperieren, außer Gegner hat 2x verraten      |

Als Rekombinationen wurde der One-Point-Crossover (Weicker, 2024), sowie der
Uniform-Crossover (Weicker, 2024) implementiert.

Weiterhin wurden die One-Flip-Mutation umgesetzt, welche die Aktion für eine
zufällige Bedingung tauscht. Als Alternative kommt die probabilistische Mutation
hinzu, welche für jede Bedingung zufällig die Aktion herumdreht.

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

Das o.g. Konzept wurde in Swift umgesetzt und kann lokal oder in einem
[Docker](https://www.docker.com/)- bzw. [Podman](https://podman.io/)-Container
gestartet werden. Eine Anleitung zur Verwendung kann in der `README` des
Repositories unter dem Abschnitt
[„Usage“](https://github.com/nicosrm/24-ea-ipd/blob/main/README.md#usage)[^1]
nachgeschlagen werden.

Es müssen lediglich die Mutations- und Rekombinationsrate beim Start des
Programmes als Argument übergeben werden. Die anderen Argumente sind wie folgt
standardmäßig initialisiert.

| Argument               | Standardwert  |
|------------------------|---------------|
| `populationSize`       | 100           |
| `epochCount`           | 30            |
| `matchIterationCount`  | 50            |
| `mutation`             | `one-flip`    |
| `mutationRate`         | ---           |
| `crossover`            | `uniform`     |
| `recombinationRate`    | ---           |
| `selection`            | `established` |
| `tournamentSteps`      | 10            |

Dabei sei angemerkt, dass die `matchIterationCount` beschreibt dabei, wie viele
Runden pro Spiel, d.h. Strategie vs. Strategie, gespielt werden sollen. Ferne
bestimmt das `tournamentSteps`-Argument das $q$ bei der $q$-stufigen 
Turnierselektion.


## Ergebnisse

TBA


<!-- ----------------------------------------------------------------------- -->

[^1]: [`https://github.com/nicosrm/24-ea-ipd/blob/main/README.md#usage`](https://github.com/nicosrm/24-ea-ipd/blob/main/README.md#usage)
