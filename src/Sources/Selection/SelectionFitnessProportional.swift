//
//  SelectionFitnessProportional.swift
//
//  Created by nicosrm
//

import Foundation

/// Selection proportional to (fitness) ``Tournament/scores``.
///
/// The better the score of the individual, the more likely it is to be
/// selected, hence fitness proportionate selection (Weicker, 2024).
struct SelectionFitnessProportional: SelectionProtocol {
    
    static func select(_ k: Int, from sortedScores: [Int]) -> [Int] {
        let totalScores = sortedScores.reduce(0, +)
        
        var indices = [Int]()
        
        for _ in 0..<k {
            let randomScore = Double.random(in: 0...Double(totalScores))
            
            var cumulativeScore = 0.0
            for (index, score) in sortedScores.enumerated() {
                cumulativeScore += Double(score)
                if cumulativeScore >= randomScore {
                    indices.append(index)
                    continue
                }
            }
        }
        
        return indices
    }
}
