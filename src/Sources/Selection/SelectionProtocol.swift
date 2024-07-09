//
//  SelectionProtocol.swift
//
//  Created by nicosrm
//

import Foundation
import ArgumentParser

protocol SelectionProtocol {
    
    var population: [GeneticStrategy] { get }
    var selectionCount: Int { get }
    
    var directTournamentCount: Int { get }
    var matchIterationCount: Int { get }
    
    init(
        population: [GeneticStrategy],
        selectionCount: Int,
        directTournierCount: Int,
        matchIterationCount: Int
    )
    
    func select() -> [(GeneticStrategy, Int)]
}

enum Selection: String, CaseIterable, ExpressibleByArgument {
    
    case oneStepTournament = "1-tournament"
    
    func getProtocol() -> SelectionProtocol.Type {
        switch self {
        case .oneStepTournament:
            return OneStepTournamentSelection.self
        }
    }
}
