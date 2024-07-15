//
//  Evolution.swift
//
//  Created by nicosrm
//

import Foundation

class Evolution {
    
    private (set) var population: [GeneticStrategy]
    
    /// Number of iterations to run tournaments of best strategies.
    let epochCount: Int
    
    /// Number of iterations per match of strategy v. strategy.
    let matchIterationCount: Int
    
    let mutation: any MutationProtocol
    let mutationRate: Double
    
    let crossover: any CrossoverProtocol.Type
    let recombinationRate: Double
    
    let selection: any SelectionProtocol.Type
    let tournamentSteps: Int
    
    /// Create new instance of ``Evolution``.
    ///
    /// # Parameter Constraints
    /// Note the following parameter constraints:
    /// - `populationSize` must be an even number >= 2
    /// - ``mutationRate`` and ``recombinationRate`` must be in [0,1]
    init(
        populationSize: Int,
        epochCount: Int,
        matchIterationCount: Int,
        mutation: any MutationProtocol,
        mutationRate: Double,
        crossover: any CrossoverProtocol.Type,
        recombinationRate: Double,
        selection: any SelectionProtocol.Type,
        tournamentSteps: Int
    ) {
        assert(populationSize >= 2,
               "Population must have at least two individuals.")
        assert(populationSize % 2 == 0,
               "Population size must be an even number.")
        
        // generate random genetic population
        self.population = []
        for _ in 0..<populationSize {
            let randomStrategy = GeneticStrategy()
            self.population.append(randomStrategy)
        }
        
        self.epochCount = epochCount
        self.matchIterationCount = matchIterationCount
        self.mutation = mutation
        
        assert(mutationRate >= 0 && mutationRate <= 1,
               "Mutation rate must in [0,1]")
        self.mutationRate = mutationRate
        
        self.crossover = crossover
        
        assert(recombinationRate >= 0 && recombinationRate <= 1,
               "Recombination rate must in [0,1]")
        self.recombinationRate = recombinationRate
        
        self.selection = selection
        
        assert(tournamentSteps >= 1, "Tournament steps must be at least 1!")
        self.tournamentSteps = tournamentSteps
    }
    
    /// Run evolution with defined parameters to determine best strategy.
    func run() -> StrategyScorePair {
        for epoch in 0..<epochCount {
            log.log("Epoch \(epoch + 1) / \(epochCount)")
            
            // select individuals
            let selection = self.select(self.population.count)
            
            let best = selection.best!
            log.log("Best strategy (score: \(best.score))")
            best.strategy.debugPrint(includeHistory: false)
            
            // create new population by performing recombination / mutation
            let newPopulation = self.recombineAndMutate(
                selection.map { $0.strategy }
            )
            
            // update population
            self.population = newPopulation
            
            log.log("\n")
        }
        
        // determine best strategy
        log.log("Playing final tournament...")
        let best = self.select(1).first!
        return best
    }
}

// MARK: - Private helpers

private extension Evolution {
    
    func select(
        _ selectionCount: Int
    ) -> [StrategyScorePair] {
        log.log("Selecting individuals of population...")
        
        let selectionInstance = self.selection.init(
            population: self.population,
            selectionCount: selectionCount,
            directTournierCount: self.tournamentSteps,
            matchIterationCount: self.matchIterationCount
        )
        let selection = selectionInstance.select()
        return selection
    }
    
    /// Create new population based on passed selection by performing
    /// recombination and mutation, see ``recombineOrMutate``.
    func recombineAndMutate(_ selection: [GeneticStrategy]) -> [GeneticStrategy] {
        log.log("Recombining and mutating selection...")
        var newPopulation = [GeneticStrategy]()
        
        for i in 0..<(selection.count / 2) {
            let parentA = selection[2 * i]
            let parentB = selection[2 * i + 1]
            
            let (childA, childB) = self.recombineOrMutate(
                parentA: parentA,
                parentB: parentB
            )
            newPopulation.append(childA)
            newPopulation.append(childB)
        }
        
        log.log("Created new population.")
        return newPopulation
    }
    
    /// Recombine (i.e. crossover) or mutate passed ``GeneticStrategy``s based
    /// on drawn random probability. Use initially passed ``recombinationRate``,
    /// ``crossover``, and ``mutation``.
    func recombineOrMutate(
        parentA: GeneticStrategy,
        parentB: GeneticStrategy
    ) -> (GeneticStrategy, GeneticStrategy) {
        let u = Double.random(in: 0...1)
        
        if u <= self.recombinationRate {
            return self.crossover.crossover(parentA, parentB)
        }
        
        let childA = self.mutation.mutate(parentA)
        let childB = self.mutation.mutate(parentB)
        return (childA, childB)
    }
}
