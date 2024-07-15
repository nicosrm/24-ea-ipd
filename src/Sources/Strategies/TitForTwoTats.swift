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
    
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Tit for Two Tats"
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = (opponentHistory.suffix(2) == [Move.D, Move.D])
            ? Move.D : Move.C
        self.history.append(move)
        return move
    }
}
