//
//  TitForTwoTats.swift
//
//  Created by nicosrm
//

import Foundation

/// Cooperate unless opponent defected twice in a row (Kuhn, 2019).
class TitForTwoTats: StrategyProtocol {
    
    var name: String
    var history: MoveHistory
    
    init(initialHistory: MoveHistory) {
        self.name = "Tit for Two Tats"
        self.history = initialHistory
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = (opponentHistory.suffix(3) == [Move.D, Move.D])
            ? Move.D : Move.C
        self.history.append(move)
        return move
    }
}
