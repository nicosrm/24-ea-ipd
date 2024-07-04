//
//  CrossoverProtocol.swift
//
//  Created by nicosrm
//

import Foundation
import ArgumentParser

protocol CrossoverProtocol {
    
    /// Crossover two strategies (parents) to create a two new ones (children).
    static func crossover(
        _ parentA: GeneticStrategy,
        _ parentB: GeneticStrategy
    ) -> (GeneticStrategy, GeneticStrategy)
}

enum Crossover: String, CaseIterable, ExpressibleByArgument {
    
    case onePoint = "one-point"
    case uniform = "uniform"
    
    func getProtocol() -> CrossoverProtocol.Type {
        switch self {
        case .onePoint:
            return OnePointCrossover.self
        case .uniform:
            return UniformCrossover.self
        }
    }
}
