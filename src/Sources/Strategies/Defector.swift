//
//  Defector.swift
//
//  Created by nicosrm
//

import Foundation

/// Defect unconditionally (Kuhn, 2019)
class Defector: StrategyProtocol {
    
    var name: String
    var history: MoveHistory
    
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Unconditional defector"
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = Move.D
        self.history.append(move)
        return move
    }
}
