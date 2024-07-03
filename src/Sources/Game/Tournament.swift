//
//  Tournament.swift
//
//  Created by nicosrm
//

import Foundation

/// Tournament between passed ``population`` of strategies (players) that will
/// be played and scored against each other. The resulting scores are updated
/// after each ``Match`` between two strategies. At the end of the tournament,
/// the final results are stored in ``scores``.
class Tournament {
    
    /// Members of the tournament (*population*), i.e. players / strategies.
    let population: [any StrategyProtocol]
    
    /// Array to keep scores of ``population``.
    /// Indices are the same as in ``population``.
    private (set) var scores: [Int]
    
    /// Number of turns to be played per match between two players / strategies.
    let iterationCount: Int
        
    init(population: [any StrategyProtocol], iterationCount: Int) {
        self.population = population
        
        // initialize scores with 0
        self.scores = Array(repeating: 0, count: population.count)
        
        assert(iterationCount > 0, "At least one iteration must be done!")
        self.iterationCount = iterationCount
    }
    
    /// Create ``Tournament`` with `populationSize` many random
    /// ``GeneticStrategy``s as a population.
    ///
    /// # Note
    /// Each ``GeneticStrategy/history`` of the individuals will be initialised
    /// with random values. Also, a population must have at least two
    /// individuals.
    convenience init(populationSize: Int, iterationCount: Int) {
        assert(populationSize >= 2,
               "Population must have at least two individuals.")
        
        // generate random population
        var randomPopulation = [any StrategyProtocol]()
        for _ in 0..<populationSize {
            let individual = GeneticStrategy()
            randomPopulation.append(individual)
        }
        
        self.init(population: randomPopulation, iterationCount: iterationCount)
    }
    
    /// Play each player (i.e. strategy) of ``population`` against each player.
    func play() {
        for indexA in 0..<population.count {
            for indexB in 0..<population.count {
                self.run(indexA, against: indexB)
            }
        }
    }
    
    /// Get `k` best strategies of ``population``.
    ///
    /// # Note
    /// For reasonable results, ``play()`` should be called first.
    func getBestStrategies(_ k: Int) -> [any StrategyProtocol] {
        assert(k >= self.population.count,
               "\(k) is out of population bounds.")
        
        let bestStrategies = self.sortedPopulation.prefix(k)
        return Array(bestStrategies)
    }
}

// MARK: - Private helpers

private extension Tournament {
    
    /// Play a ``Match`` between players at passed indices of ``population``.
    /// Update ``scores`` array correspondingly.
    func run(_ indexA: Int, against indexB: Int) {
        // get corresponding players
        let playerA = self.population[indexA]
        let playerB = self.population[indexB]
        
        // create match
        let match = Match(
            playerA: playerA,
            playerB: playerB,
            turns: self.iterationCount
        )
        
        // play one round
        match.play()
        
        // update scores
        let score = match.game.score
        scores[indexA] += score.A
        scores[indexB] += score.B
    }
    
    /// ``population`` sorted by ``scores``
    var sortedPopulation: [any StrategyProtocol] {
        let zip = Array(zip(population, scores))
        let sorted = zip.sorted { a, b in
            return a.1 < b.1
        }
        return sorted.map { $0.0 }
    }
}
