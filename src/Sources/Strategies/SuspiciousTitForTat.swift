//
//  SuspiciousTitForTat.swift
//
//  Created by nicosrm
//

import Foundation

/// Defect on the first round. Imitate opponent's previous move
/// thereafter (Kuhn, 2019).
class SuspiciousTitForTat: StrategyProtocol {
    
    var name: String
    var history: MoveHistory
    
    init(initialHistory: MoveHistory) {
        self.name = "Suspicious Tit for Tat"
        self.history = initialHistory
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let move = (self.history.isEmpty || opponentHistory.isEmpty)
            ? .D : opponentHistory.last!
        self.history.append(move)
        return move
    }
}
