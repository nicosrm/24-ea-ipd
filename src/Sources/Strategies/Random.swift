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
    
    init(initialHistory: MoveHistory) {
        self.name = "Random"
        self.history = initialHistory
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = Move.random
        self.history.append(move)
        return move
    }
}
