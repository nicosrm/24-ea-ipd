//
//  Example.swift
//
//  Created by nicosrm
//

import Foundation

struct Example {
    
    static func crossoverExample() {
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
    
    static func mutationExample() {
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
    
    static func tournamentExample() {
        let populationSize = 10
        let tournament = Tournament(populationSize: populationSize, iterationCount: 5)
        tournament.play()
        
        log.log("**Tournament scores**")
        log.log(tournament.scores.sorted(by: >))
    }
    
    static func evolutionExample(
        populationSize: Int,
        epochCount: Int,
        matchIterationCount: Int,
        mutation: Mutation,
        mutationRate: Double,
        crossover: Crossover,
        recombinationRate: Double,
        selection: Selection
    ) {
        log.log("population size: \(populationSize)")
        log.log("epoch count: \(epochCount)")
        log.log("match iteration count: \(matchIterationCount)")
        log.log("mutation: \(mutation.rawValue)")
        log.log("mutation rate: \(mutationRate)")
        log.log("recombination: \(crossover.rawValue)")
        log.log("recombination rate: \(recombinationRate)")
        log.log("selection: \(selection.rawValue)")
        log.log("\n")
        
        log.newFile(
            logFileName: "ipd-\(mutationRate)-\(recombinationRate)-" +
            "\(Logger.formattedCurrentDate).log")
        log.log()
        
        let mutationInstance: MutationProtocol = switch mutation {
        case .oneFlip: OneFlipMutation()
        case .probabilistic: ProbabilisticMutation(mutationRate: mutationRate)
        }
        
        let crossoverProtocol: CrossoverProtocol.Type = switch crossover {
        case .onePoint: OnePointCrossover.self
        case .uniform: UniformCrossover.self
        }
        
        let selectionProtocol: SelectionProtocol.Type = switch selection {
        case .oneStepTournament: OneStepTournamentSelection.self
        }
        
        let evolution = Evolution(
            populationSize: populationSize,
            epochCount: epochCount,
            matchIterationCount: matchIterationCount,
            mutation: mutationInstance,
            mutationRate: mutationRate,
            crossover: crossoverProtocol,
            recombinationRate: recombinationRate,
            selection: selectionProtocol
        )
        let (bestStrategy, score) = evolution.run()
        log.log()
        log.log(bestStrategy.moveTable.sorted(by: <))
        log.log("with score \(score)")
    }
    
    static func printDivider() {
        log.log()
        log.log(String(repeating: "=", count: 100))
        log.log()
    }
}
