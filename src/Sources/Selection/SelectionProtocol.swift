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
    
    func select() -> [StrategyScorePair]
}

enum Selection: String, CaseIterable, ExpressibleByArgument {
    
    case tournament = "tournament"
    
    func getProtocol() -> SelectionProtocol.Type {
        switch self {
        case .tournament:
            return TournamentSelection.self
        }
    }
}
