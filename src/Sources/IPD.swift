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
    var populationSize: Int = 50
    
    @Option(name: .long, help: "Number of epochs")
    var epochCount: Int = 30
    
    @Option(name: .long, help: "Number of iterations per match")
    var matchIterationCount: Int = 25
    
    @Option(name: .long, help: "Mutation protocol")
    var mutation: Mutation = .oneFlip
    
    @Option(name: .shortAndLong, help: "Mutation rate")
    var mutationRate: Double
    
    @Option(name: .long, help: "Crossover protocol")
    var crossover: Crossover = .onePoint
    
    @Option(name: .shortAndLong, help: "Recombination rate")
    var recombinationRate: Double
    
    @Option(name: .long, help: "Selection protocol")
    var selection: Selection = .oneStepTournament
    
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
            selection: selection.getProtocol()
        )
        
        let (bestStrategy, score) = evolution.run()
        log.log()
        log.log("Best strategy")
        bestStrategy.debugPrint(includeHistory: false)
        log.log("with score \(score)")
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
        log.log("\n")
    }
}
