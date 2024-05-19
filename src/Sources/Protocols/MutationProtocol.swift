//
//  MutationProtocol.swift
//
//  Created by nicosrm
//

import Foundation

protocol MutationProtocol {
    
    /// Probability with with to mutate.
    /// Must be between 0 and 1.
    var mutationRate: Double { get }
    
    /// Mutate passed strategy based on ``mutationRate``, i.e. randomly
    /// choose some part of the ``StrategyProtocol.moveTable``.
    /// 
    /// - Returns: Mutated strategy.
    static func mutate(_ strategy: GeneticStrategy) -> GeneticStrategy
}
