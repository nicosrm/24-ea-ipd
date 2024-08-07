# Iterative Prisoner's Dilemma

In this repository, the possibility to train strategies for the Iterative
Prisoner's Dilemma (IPD) using evolutionary algorithms is examined.

The *Prisoner's Dilemma* (PD) is a thought experiment in game theory involving
two entities that have been arrested and placed in separate, isolated cells. The
prosecutor offers them the so called following *Prisoner's Dilemma*
(Kuhn, 2019).

> You may choose to confess or remain silent. If you confess and your accomplice
> remains silent I will drop all charges against you and use your testimony to
> ensure that your accomplice does serious time. Likewise, if your accomplice
> confesses while you remain silent, they will go free while you do the time. If
> you both confess I get two convictions, but I'll see to it that you both get
> early parole. If you both remain silent, I'll have to settle for token
> sentences on firearms possession charges. If you wish to confess, you must
> leave a note with the jailer before my return tomorrow morning (Kuhn, 2019).

That leads to the following table (Axelrod, 1997):

|               | **Cooperate**                                               | **Defect**                                                  |
|---------------|-------------------------------------------------------------|-------------------------------------------------------------|
| **Cooperate** | $R = 3, R = 3$<br>reward for mutual cooperation             | $S = 0, T = 5$<br>sucker's payoff, and temptation to defect |
| **Defect**    | $T = 5, S = 0$<br>temptation to defect, and sucker's payoff | $P = 1, P = 1$<br>punishment for mutual defection           |

The prisoners in this situation are in a dilemma where confessing is a better
option for each of them, regardless of the other's choice. However, if both
confess, the outcome is worse for both compared to if they had both stayed
silent (Kuhn, 2019).

Alleged prisoner's dilemma situations are often better represented by an
*iterated* version of the game. In these *Iterated Prisoner's Dilemmas* (IPDs),
the players can react to the previous moves of their opponent and therefore
punish defections or reward cooperations. Now, the best strategy for "rationally
self-interested players" is no longer obvious (Kuhn, 2019). Therefore, the goal
in this project is to explore the generation of new strategies using genetic
algorithms.


## Structure

| Path                                       | Description                                           |
|--------------------------------------------|-------------------------------------------------------|
| `src/`                                     | source files                                          |
| [`doc/doc.preview.md`](doc/doc.preview.md) | documentation                                         |
| [`bibliography.md`](bibliography.md)       | bibliography notices                                  |


## Context

- Project for *C195: Evolutionary Algorithms* by [Prof Karsten Weicker](https://fim.htwk-leipzig.de/fakultaet/personen/professorinnen-und-professoren/karsten-weicker/)


## Usage

### Local Usage

```
$ cd src
$ swift build
$ swift run ipd -m <mutation-rate> -r <recombination-rate>
```

The resulting info logs will be stored in `src/logs/`.


### Using with Docker

```
$ docker build -t ipd .
$ docker run -it --rm --name ipd ipd
# now inside container
$ swift run ipd -m <mutation-rate> -r <recombination-rate>
```

To copy the logs, run the following command:

```
$ docker cp ipd:logs/. src/logs
```


### Arguments

```
$ swift run ipd --help
USAGE: ipd [--population-size <population-size>] \
           [--epoch-count <epoch-count>] \
           [--match-iteration-count <match-iteration-count>] \
           [--mutation <mutation>] \
           --mutation-rate <mutation-rate> \
           [--crossover <crossover>] \
           --recombination-rate <recombination-rate> \
           [--selection <selection>] \
           [--tournament-steps <tournament-steps>]

OPTIONS:
  --population-size <population-size>
                          Number of individuals in population (default: 100)

  --epoch-count <epoch-count>
                          Number of epochs (default: 30)

  --match-iteration-count <match-iteration-count>
                          Number of iterations per match (default: 50)

  --mutation <mutation>   Mutation protocol (values: one-flip, probabilistic; default: one-flip)

  -m, --mutation-rate <mutation-rate>
                          Mutation rate

  --crossover <crossover> Crossover protocol (values: one-point, uniform; default: uniform)

  -r, --recombination-rate <recombination-rate>
                          Recombination rate

  --selection <selection> Selection protocol (values: tournament, established; default: established)

  -t, --tournament-steps <tournament-steps>
                          Steps of each tournament (default: 10)

  -h, --help              Show help information.
```


## License

This project is licensed under the [MIT License](LICENSE).
