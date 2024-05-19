//
//  CrossoverProtocol.swift
//
//  Created by nicosrm
//

import Foundation

protocol CrossoverProtocol {
    
    /// Crossover two strategies (parents) to create a two new ones (children).
    static func crossover(
        _ parentA: GeneticStrategy,
        _ parentB: GeneticStrategy
    ) -> (GeneticStrategy, GeneticStrategy)
}
