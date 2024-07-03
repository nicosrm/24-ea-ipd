//
//  MutationProtocol.swift
//
//  Created by nicosrm
//

import Foundation

protocol MutationProtocol {
    
    /// Probability with which to mutate. Must be between 0 and 1.
    /// Might be `nil` if mutation operator is not probibalistic.
    ///
    /// Optimal mutation rate is the reciprocal length of the move table
    /// (Weicker, 2024).
    var mutationRate: Double? { get }
    
    /// Mutate passed strategy based on ``mutationRate``, i.e. randomly
    /// choose some part of the ``GeneticStrategy.moveTable``.
    ///
    /// - Returns: Mutated strategy.
    func mutate(_ strategy: GeneticStrategy) -> GeneticStrategy
}