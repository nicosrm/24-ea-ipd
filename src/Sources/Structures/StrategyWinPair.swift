//
//  StrategyWinPair.swift
//
//  Created by nicosrm
//

import Foundation

struct StrategyWinPair {
    
    let strategy: GeneticStrategy
    let wins: Int
    
    init(strategy: GeneticStrategy, wins: Int) {
        self.strategy = strategy
        self.wins = wins
    }
}

extension [StrategyWinPair] {
    
    var sortedByScore: Self {
        let sorted = self.sorted { $0.wins > $1.wins }
        return sorted
    }

    var best: Self.Element? {
        return self.sortedByScore.first
    }
}
