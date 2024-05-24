//
//  ProbibalisticMutation.swift
//
//  Created by nicosrm
//

import Foundation

/// Draw a random number for each opponent's move set. If the random number
/// exceeds the ``mutationRate``, flip the played move. Take the parent's move
/// otherwise (Weicker, 2024).
struct ProbabilisticMutation: MutationProtocol {
    
    let mutationRate: Double?
    
    init(mutationRate: Double) {
        self.mutationRate = mutationRate
    }
    
    func mutate(_ strategy: GeneticStrategy) -> GeneticStrategy {
        var childMoveTable = strategy.moveTable
        
        for (key, value) in strategy.moveTable {
            let probability = Double.random(in: 0..<1)
            
            if probability <= mutationRate! {
                childMoveTable[key] = value.flip
            }
        }
        
        return strategy.copyWith(moveTable: childMoveTable)
    }
    
    
}
