//
//  TitForTat.swift
//
//  Created by nicosrm
//

import Foundation

/// Cooperate on the first round. Imitate opponent's previous move
/// thereafter (Kuhn, 2019).
class TitForTat: StrategyProtocol {
    
    var name: String
    var history: MoveHistory
    
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Tit for Tat"
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = (self.history.isEmpty || opponentHistory.isEmpty) 
            ? .C : opponentHistory.last!
        self.history.append(move)
        return move
    }
}
