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

func evolutionExample(mutationRate: Double, recombinationRate: Double) {
    let populationSize = 50
    let epochCount = 30
    let matchIterationCount = 25
    
    log.log("mutation rate: \(mutationRate)")
    log.log("recombination rate: \(recombinationRate)")
    log.log()
    
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

func largeExample() {
    let mutationRates = [0.001, 0.005, 0.01]
    let recombinationRates = [0.6, 0.7, 0.8, 0.9]
    
    for mutationRate in mutationRates {
        for recombinationRate in recombinationRates {
            log.newFile(logFileName: "ipd-\(mutationRate)-\(recombinationRate)")
            
            for _ in 0..<10 {
                evolutionExample(mutationRate: mutationRate,
                                 recombinationRate: recombinationRate)
                printDivider()
            }
        }
    }
}

//crossoverExample()
//printDivider()
//mutationExample()
//printDivider()
//tournamentExample()

largeExample()
