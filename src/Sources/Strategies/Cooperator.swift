//
//  Cooperator.swift
//
//  Created by nicosrm
//

import Foundation

/// Cooperate unconditionally (Kuhn, 2019)
class Cooperator: StrategyProtocol {
    
    var name: String
    var history: MoveHistory
    
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Unconditional cooperator"
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = Move.C
        self.history.append(move)
        return move
    }
}
