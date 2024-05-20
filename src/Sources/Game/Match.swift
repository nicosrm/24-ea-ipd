//
//  Match.swift
//
//  Created by nicosrm
//

import Foundation

/// Match between two players. Play game with specified number of ``turns``.
/// Store ``Game/score`` in ``game`` and played moves in ``moves``.
class Match {
    
    let playerA: any StrategyProtocol
    let playerB: any StrategyProtocol
    
    // Game object to manage scores
    let game: Game
    
    /// Number of turns to play.
    let turns: Int
    
    /// Moves of ``playerA`` and ``playerB`` during the game.
    private (set) var moves: [MovePair]
    
    /// Initialize new match with both players and number of ``turns`` to play.
    ///
    /// Both players have to be initialized with their corresponding three
    /// initial moves (see ``StrategyProtocol/history``.
    init?(
        playerA: any StrategyProtocol,
        playerB: any StrategyProtocol,
        turns: Int
    ) {
        assert(playerA.history.count >= 3,
               "playerA does not have initial history")
        assert(playerB.history.count >= 3,
               "playerB does not have initial history")
        assert(turns > 0,
               "Number of turnes must be at least 1")
        
        self.playerA = playerA
        self.playerB = playerB
        
        self.game = Game(playerA: playerA, playerB: playerB)
        
        self.turns = turns
        self.moves = [MovePair]()
    }
    
    /// Play ``playerA`` against ``playerB`` as often as specified in ``turns``.
    /// Play initial three rounds first. Update ``Game``'s ``Game/score`` and
    /// ``moves`` after each round accordingly.
    func play() {
        for initialRoundIndex in 0..<3 {
            let moveA = self.playerA.history[initialRoundIndex]
            let moveB = self.playerB.history[initialRoundIndex]
            self.updateMovesAndScore(moveA, moveB)
        }
        
        for _ in 1...turns {
            // copy history before new move is commited
            let historyA = playerA.history
            
            let moveA = self.playerA.makeMove(opponentHistory: playerB.history)
            let moveB = self.playerB.makeMove(opponentHistory: historyA)
            self.updateMovesAndScore(moveA, moveB)
        }
    }
}

private extension Match {
    
    /// Append passed moves of one round of the match to ``moves`` and update
    /// ``game``'s ``Game/score``.
    func updateMovesAndScore(_ moveA: Move, _ moveB: Move) {
        let result = MovePair(moveA, moveB)
        self.moves.append(result)
        self.game.updateScoreWith(result)
    }
}
