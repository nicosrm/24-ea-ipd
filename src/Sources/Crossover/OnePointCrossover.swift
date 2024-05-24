//
//  OnePointsCrossover.swift
//
//  Created by nicosrm
//

import Foundation

/// Pick random position in ``GeneticStrategy/moveTable``'s keys as crossover
/// point. Right of the crossover point, swap the segments of both parents,
/// resulting in two children.
///
/// # Example
///
/// ```plain
/// crossover point: 3
/// 
/// parentA: aaa | aaa
/// parentB: bbb | bbb
///
///      --> aaa | bbb (childA)
///      --> bbb | aaa (childB)
///                ^^^ <-- swapped
/// ```
struct OnePointCrossover: CrossoverProtocol {
    
    static func crossover(
        _ parentA: GeneticStrategy,
        _ parentB: GeneticStrategy
    ) -> (GeneticStrategy, GeneticStrategy) {
        assert(parentA.moveTable.keys == parentB.moveTable.keys,
               "Move table keys of parents are not matching")
        let keys = parentA.moveTable.keys
        
        // pick random crossover point
        let crossoverPoint = Int.random(in: 0..<keys.count)
        
        var moveTableA = GeneticStrategy.MoveTable()
        var moveTableB = GeneticStrategy.MoveTable()
        
        // generate children's move tables
        for (i, key) in keys.enumerated() {
            if i <= crossoverPoint {
                // copy when left of crossover point
                moveTableA[key] = parentA.moveTable[key]
                moveTableB[key] = parentB.moveTable[key]
            } else {
                // swap values when right of crossover point
                moveTableA[key] = parentB.moveTable[key]
                moveTableB[key] = parentA.moveTable[key]
            }
        }
        
        let childA = parentA.copyWith(moveTable: moveTableA)
        let childB = parentB.copyWith(moveTable: moveTableB)
        
        return (childA, childB)
    }
}
