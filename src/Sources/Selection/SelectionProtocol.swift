//
//  SelectionProtocol.swift
//
//  Created by nicosrm
//

import Foundation
import ArgumentParser

protocol SelectionProtocol {
    
    /// Determine indices of `k` individuals to select based on their
    /// ``Tournament/scores``.
    /// Note that the passed scores need to be sorted descensional.
    static func select(_ k: Int, from sortedScores: [Int]) -> [Int]
}

enum Selection: String, CaseIterable, ExpressibleByArgument {
    
    case fitnessProportional = "fitness-proportional"
    
    func getProtocol() -> SelectionProtocol.Type {
        switch self {
        case .fitnessProportional:
            return SelectionFitnessProportional.self
        }
    }
}
