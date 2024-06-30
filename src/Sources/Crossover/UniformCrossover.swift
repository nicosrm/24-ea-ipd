//
//  UniformCrossover.swift
//
//  Created by nicosrm
//

import Foundation

/// Decide for each key of the ``GeneticStrategy/moveTable`` individually and
/// randomly /// from which parent to take the move (Weicker, 2024).
struct UniformCrossover: CrossoverProtocol {
    
    static func crossover(
        _ parentA: GeneticStrategy,
        _ parentB: GeneticStrategy
    ) -> (GeneticStrategy, GeneticStrategy) {
        assert(parentA.moveTable.keys == parentB.moveTable.keys,
               "Move table keys of parents are not matching")
        let keys = parentA.moveTable.keys
        
        // initialize new children move tables
        var moveTableA = GeneticStrategy.MoveTable()
        var moveTableB = GeneticStrategy.MoveTable()
        
        for key in keys {
            // decide randomly which key to take
            if Bool.random() {
                // A --> A, B --> B
                moveTableA[key] = parentA.moveTable[key]
                moveTableB[key] = parentB.moveTable[key]
            } else {
                // A --> B, B --> A
                moveTableA[key] = parentB.moveTable[key]
                moveTableB[key] = parentA.moveTable[key]
            }
        }
        
        // generate new children
        let childA = parentA.copyWith(moveTable: moveTableA)
        let childB = parentB.copyWith(moveTable: moveTableB)
        
        return (childA, childB)
    }
}
