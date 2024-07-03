//
//  main.swift
//
//  Created by nicosrm
//

import Foundation

func crossoverExample() {
    let strategyA = GeneticStrategy(history: [.C, .C, .C])
    let strategyB = GeneticStrategy(history: [.C, .C, .C])
    
    log.log("**Strategy A**")
    strategyA.debugPrint()
    log.log()
    log.log("**Strategy B**")
    strategyB.debugPrint()
    log.log()
    
    let (childA, childB) = OnePointCrossover.crossover(strategyA, strategyB)
//    let (childA, childB) = UniformCrossover.crossover(strategyA, strategyB)
    
    log.log("**Child A**")
    childA.debugPrint()
    log.log()
    log.log("**Child B**")
    childB.debugPrint()
}

func mutationExample() {
    let parent = GeneticStrategy(history: [.C, .C, .C])
    log.log("**Parent**")
    parent.debugPrint()
    
    log.log()
    log.log("**One Flip Mutation**")
    OneFlipMutation().mutate(parent).debugPrint()
    
    log.log()
    log.log("**Probabilistic Mutation**")
    ProbabilisticMutation(mutationRate: 0.1).mutate(parent).debugPrint()
}

func tournamentExample() {
    let populationSize = 10
    let tournament = Tournament(populationSize: populationSize, iterationCount: 5)
    tournament.play()
    
    log.log("**Tournament scores**")
    log.log(tournament.scores.sorted(by: >))
}

func evolutionExample() {
    let populationSize = 30
    let epochCount = 20
    let matchIterationCount = 20
    let mutationRate = 0.01
    let recombinationRate = 0.7
    
    let evolution = Evolution(
        populationSize: populationSize,
        epochCount: epochCount,
        matchIterationCount: matchIterationCount,
        mutation: ProbabilisticMutation(mutationRate: mutationRate),
        mutationRate: mutationRate,
        crossover: OnePointCrossover.self,
        recombinationRate: recombinationRate,
        selection: SelectionFitnessProportional.self
    )
    let (bestStrategy, score) = evolution.run()
    log.log()
    log.log(bestStrategy.moveTable)
    log.log("with score \(score)")
}

func printDivider() {
    log.log()
    log.log(String(repeating: "=", count: 100))
    log.log()
}

//crossoverExample()
//printDivider()
//mutationExample()
//printDivider()
//tournamentExample()

evolutionExample()
