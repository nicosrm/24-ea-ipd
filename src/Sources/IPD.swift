//
//  IPD.swift
//
//  Created by nicosrm
//

import Foundation
import ArgumentParser

@main
struct IPD: ParsableCommand {
    
    @Option(name: .long, help: "Number of individuals in population")
    var populationSize: Int = 100
    
    @Option(name: .long, help: "Number of epochs")
    var epochCount: Int = 30
    
    @Option(name: .long, help: "Number of iterations per match")
    var matchIterationCount: Int = 50
    
    @Option(name: .long, help: "Mutation protocol")
    var mutation: Mutation = .oneFlip
    
    @Option(name: .shortAndLong, help: "Mutation rate")
    var mutationRate: Double
    
    @Option(name: .long, help: "Crossover protocol")
    var crossover: Crossover = .uniform
    
    @Option(name: .shortAndLong, help: "Recombination rate")
    var recombinationRate: Double
    
    @Option(name: .long, help: "Selection protocol")
    var selection: Selection = .established
    
    @Option(name: .shortAndLong, help: "Steps of each tournament")
    var tournamentSteps: Int = 10
    
    mutating func run() throws {
        logParameters()
        
        let evolution = Evolution(
            populationSize: populationSize,
            epochCount: epochCount,
            matchIterationCount: matchIterationCount,
            mutation: mutation.getInstance(mutationRate: mutationRate),
            mutationRate: mutationRate,
            crossover: crossover.getProtocol(),
            recombinationRate: recombinationRate,
            selection: selection.getProtocol(),
            tournamentSteps: tournamentSteps
        )
        
        let best = evolution.run()
        log.log()
        log.log("Best strategy (score: \(best.score))")
        best.strategy.debugPrint(includeHistory: false)
    }
}

private extension IPD {
    
    func logParameters() {
        log.log("population size: \(populationSize)")
        log.log("epoch count: \(epochCount)")
        log.log("match iteration count: \(matchIterationCount)")
        log.log("mutation: \(mutation.rawValue)")
        log.log("mutation rate: \(mutationRate)")
        log.log("recombination: \(crossover.rawValue)")
        log.log("recombination rate: \(recombinationRate)")
        log.log("selection: \(selection.rawValue)")
        log.log("tournament steps: \(tournamentSteps)")
        log.log("\n")
    }
}
