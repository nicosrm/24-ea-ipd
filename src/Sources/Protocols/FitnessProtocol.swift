//
//  FitnessProtocol.swift
//
//  Created by nicosrm
//

import Foundation

protocol FitnessProtocol {
    
    // TODO: find some way to administrate points and calculate fitness
    // probably use player or something like that?
    
    /// Calculate fitness of passed strategy.
    static func calculateFitness(strategy: StrategyProtocol)
}
