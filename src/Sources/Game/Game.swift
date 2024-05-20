//
//  Game.swift
//
//  Created by nicosrm
//

import Foundation

// TODO: Rename to `ScoreHelper`?

/// Game class managing two players and their scores.
class Game {
    
    /// Pair of scores for player A and player B according to ``Game``'s
    /// ``playerA`` and ``playerB``.
    typealias ScorePair = (A: Int, B: Int)
    
    let playerA: any StrategyProtocol
    let playerB: any StrategyProtocol
    
    private (set) var score: ScorePair
    
    init(playerA: any StrategyProtocol, playerB: any StrategyProtocol) {
        self.playerA = playerA
        self.playerB = playerB
        
        self.score = (0, 0)
    }
    
    /// Add points for both players according to
    /// ``Constants/Points/payoffMatrix``.
    func updateScoreWith(_ movePair: MovePair) {
        let payoffMatrix = Constants.Points.payoffMatrix
        guard let points: ScorePair = payoffMatrix[movePair] else {
            print(">> Failure in Game.updateScoreWith(_:)")
            print(">> \(movePair) is not in payoffMatrix")
            return
        }
        
        self.score.A += points.A
        self.score.B += points.B
    }
}
