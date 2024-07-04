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
        selection: any SelectionProtocol.Type
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
    }
    
    /// Run evolution with defined parameters to determine best strategy.
    func run() -> (GeneticStrategy, Int){
        for epoch in 0..<epochCount {
            log.log("Epoch \(epoch + 1) / \(epochCount)")
            
            let tournament = Tournament(
                population: self.population,
                iterationCount: self.matchIterationCount
            )
            log.log("Playing tournament...")
            tournament.play()
            
            log.log("Scores: \(tournament.scores.sorted(by: >))")
            
            // select individuals
            let selection = self.select(basedOn: tournament)
            
            // create new population by performing recombination / mutation
            let newPopulation = self.recombineAndMutate(selection)
            
            // update population
            self.population = newPopulation
            
            log.log("\n")
        }
        
        // determine best strategy
        let tournament = Tournament(
            population: self.population,
            iterationCount: self.matchIterationCount
        )
        log.log("Playing final tournament...")
        tournament.play()
        
        log.log("Final scores: \(tournament.scores.sorted(by: >))")
        
        let bestStrategy = tournament.sortedPopulation.first! as! GeneticStrategy
        let bestScore = tournament.scores.sorted(by: >).first!
        return (bestStrategy, bestScore)
    }
}

// MARK: - Private helpers

private extension Evolution {
    
    /// Select population based on passed ``Tournament`` using initially passed
    /// ``selection`` algorithm.
    func select(basedOn tournament: Tournament) -> [GeneticStrategy] {
        log.log("Selecting individuals of population...")
        let selectionIndices = self.selection.select(
            self.population.count,
            from: tournament.scores.sorted(by: >)
        )
        let selection = selectionIndices.map { tournament.sortedPopulation[$0] }
        
        return selection as! [GeneticStrategy]
    }
    
    /// Create new population based on passed selection by performing
    /// recombination and mutation, see ``recombineOrMutate``.
    func recombineAndMutate(_ selection: [GeneticStrategy]) -> [GeneticStrategy] {
        log.log("Recombining and mutating selection...")
        var newPopulation = [GeneticStrategy]()
        
        for i in 1...(self.population.count / 2) {
            let parentA = selection[2 * i - 1]
            let parentB = selection[2 * i]
            
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
