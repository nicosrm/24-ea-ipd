//
//  Random.swift
//
//  Created by nicosrm
//

import Foundation

/// Cooperate or defect randomly.
class Random: StrategyProtocol {

    var name: String
    var history: MoveHistory
    
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Random"
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = Move.random
        self.history.append(move)
        return move
    }
}
