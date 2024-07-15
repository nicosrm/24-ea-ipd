//
//  StrategyScorePair.swift
//
//  Created by nicosrm
//

import Foundation

/// Helper struct for ``GeneticStrategy`` with a score achieved during a match,
/// tournament, selection procedure etc.
struct StrategyScorePair {
    
    let strategy: GeneticStrategy
    let score: Int
    
    init(strategy: GeneticStrategy, score: Int) {
        self.strategy = strategy
        self.score = score
    }
}

extension [StrategyScorePair] {
    
    var sortedByScore: [StrategyScorePair] {
        let sorted = self.sorted { $0.score > $1.score }
        return sorted
    }

    /// Best strategy, i.e. the strategy of the array with the highest score.
    var best: StrategyScorePair? {
        return self.sortedByScore.first
    }
}
