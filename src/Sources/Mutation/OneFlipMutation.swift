//
//  OneFlipMutation.swift
//
//  Created by nicosrm
//

import Foundation

/// Flip one random move of the ``GeneticStrategy/moveTable`` (Weicker, 2024).
struct OneFlipMutation: MutationProtocol {
    
    // Mutation rate not necessary for this mutation operator
    let mutationRate: Double? = nil
    
    func mutate(_ strategy: GeneticStrategy) -> GeneticStrategy {
        let randomPoint = strategy.moveTable.keys.randomElement()!
        
        var childMoveTable = strategy.moveTable
        childMoveTable[randomPoint] = .random
        
        return strategy.copyWith(moveTable: childMoveTable)
    }
}
