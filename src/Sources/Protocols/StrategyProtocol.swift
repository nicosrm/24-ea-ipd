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
    
    /// Make move based on passed opponent's history of moves.
    /// Append made move to ``history``.
    ///
    /// - Returns: Move that was made
    func makeMove(opponentHistory: MoveHistory) -> Move
}
