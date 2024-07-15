//
//  EstablishedStrategySelection.swift
//
//  Created by nicosrm
//

import Foundation

/// Fitness proportionate selection (Weicker, 2024) based on the scores of
/// matches of each indiviual of the ``population`` against a sample of
/// Axelrod's ``establishedStrategies`` (Kuhn, 2019).
class EstablishedStrategySelection: SelectionProtocol {
    
    let population: [GeneticStrategy]
    let selectionCount: Int
    
    /// not necessary for this selection type
    let directTournamentCount: Int
    
    let matchIterationCount: Int
    
    required init(
        population: [GeneticStrategy],
        selectionCount: Int,
        directTournierCount: Int,
        matchIterationCount: Int
    ) {
        self.population = population
        self.selectionCount = selectionCount
        self.directTournamentCount = directTournierCount
        self.matchIterationCount = matchIterationCount
    }
    
    func select() -> [StrategyScorePair] {
        let pairs = self.playTournament()
        let selection = self.selectFitnessProportionally(pairs.sortedByScore)
        return selection
    }
}

// MARK: - Private functions

private extension EstablishedStrategySelection {
    
    /// Play each individual of the ``population`` against established
    /// strategies (see ``getEstablishedStrategies()``.
    func playTournament() -> [StrategyScorePair] {
        /// cumulative score of against all established strategies
        /// matching the indices of ``population``
        var strategyWinPairs = [StrategyScorePair]()
        
        for individual in self.population {
            let establishedStrategies = self.getEstablishedStrategies()
            var score = 0
            
            // play `individual` against every established strategy
            for establishedStrategy in establishedStrategies {
                let scores = self.playMatch(
                    individual,
                    against: establishedStrategy
                )
                score += scores.A
            }
            
            strategyWinPairs.append(
                .init(strategy: individual, score: score)
            )
        }
        
        return strategyWinPairs
    }
    
    /// Select passsed ``StrategyScorePair``s based on fitness proportionate
    /// selection (Weicker, 2024).
    func selectFitnessProportionally(
        _ pairs: [StrategyScorePair]
    ) -> [StrategyScorePair] {
        let scores = pairs.map { $0.score }
        var selection = [StrategyScorePair]()
        let totalScores = scores.reduce(0, +)
        
        for _ in 0..<self.selectionCount {
            let randomScore = Double.random(in: 0...Double(totalScores))
            
            var cumulativeScore = 0.0
            for (index, score) in scores.enumerated() {
                cumulativeScore += Double(score)
                if cumulativeScore >= randomScore {
                    selection.append(pairs[index])
                    break
                }
            }
        }
        
        return selection
    }
    
    func playMatch(
        _ playerA: StrategyProtocol,
        against playerB: StrategyProtocol
    ) -> ScoreHelper.ScorePair {
        let match = Match(
            playerA: playerA,
            playerB: playerB,
            turns: self.matchIterationCount
        )
        match.play()
        return match.game.score
    }
    
    /// Get initialized ``establishedStrategies``.
    ///
    /// # Note
    /// Strategies are initialized with random ``StrategyProtocol/history``.
    func getEstablishedStrategies() -> [StrategyProtocol] {
        var strategies = [StrategyProtocol]()
        
        for strategyProtocol in establishedStrategies {
            let history: [Move] = [.random, .random, .random]
            let strategy = strategyProtocol.init(
                history: history,
                moveTable: nil
            )
            strategies.append(strategy)
        }
        
        return strategies
    }
}
