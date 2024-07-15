//
//  StrategyScorePair.swift
//
//  Created by nicosrm
//

import Foundation

struct StrategyScorePair {
    
    let strategy: GeneticStrategy
    let score: Int
    
    init(strategy: GeneticStrategy, score: Int) {
        self.strategy = strategy
        self.score = score
    }
}

extension [StrategyScorePair] {
    
    var sortedByScore: Self {
        let sorted = self.sorted { $0.score > $1.score }
        return sorted
    }

    var best: Self.Element? {
        return self.sortedByScore.first
    }
}
