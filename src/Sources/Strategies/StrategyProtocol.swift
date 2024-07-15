//
//  StrategyProtocol.swift
//
//  Created by nicosrm
//

import Foundation

protocol StrategyProtocol {
    
    typealias MoveHistory = [Move]
    
    /// Name of the strategy, e.g. "Random"
    var name: String { get }
    
    /// Own history of last moves
    var history: MoveHistory { get set }
    
    init(
        history: MoveHistory,
        moveTable: [[Move] : Move]?
    )
    
    /// Make move based on passed opponent's history of moves.
    /// Append made move to ``history``.
    ///
    /// - Returns: Move that was made
    func makeMove(opponentHistory: MoveHistory) -> Move
}

/// Array containing all implemented established strategies.
let establishedStrategies: [StrategyProtocol.Type] = [
    Cooperator.self,
    Defector.self,
    Random.self,
    SuspiciousTitForTat.self,
    TitForTat.self,
    TitForTwoTats.self,
]
