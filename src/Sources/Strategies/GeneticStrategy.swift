//
//  GeneticStrategy.swift
//
//  Created by nicosrm
//

import Foundation

/// Strategy usable for evolutionary algorithms.
class GeneticStrategy: StrategyProtocol {
    
    var name: String
    
    /// Answers to opponent's last three moves.
    ///
    /// # Example
    /// ```swift
    /// let moveTable = [
    ///     [.C, .C, .C]: .C,
    ///     [.C, .C, .D]: .D,
    ///     // ...
    /// ]
    /// ```
    let moveTable: [[Move]: Move]
    
    var history: MoveHistory
    
    /// Initialize at least the last 3 moves in `history`.
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Genetic Strategy"
        self.moveTable = moveTable ?? Self.randomMoveTable
        
        // TODO: proper error handling
        assert(history.count >= 3, "At least 3 initial moves must be specified")
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let lastThreeMoves: [Move] = opponentHistory.suffix(3)
        
        if let move = self.moveTable[lastThreeMoves] {
            self.history.append(move)
            return move
        }
        print(">> failure in GeneticStrategy makeMove")
        print(">> \(lastThreeMoves) not in move table")
        // should not happen
        return .random
    }
    
    func clearHistory() {
        self.history = []
    }
    
    func copyWith(
        history: MoveHistory? = nil,
        moveTable: [[Move] : Move]? = nil
    ) -> Self {
        return .init(
            history: history ?? self.history,
            moveTable: moveTable ?? self.moveTable
        )
    }
}

// MARK: - Helper functions

extension GeneticStrategy {
    
    /// Random move table.
    /// See ``moveTable`` for the pattern.
    static var randomMoveTable: [[Move]: Move] {
        let moveTable: [[Move]: Move] = [
            [.C, .C, .C]: .random,
            [.C, .C, .D]: .random,
            [.C, .D, .C]: .random,
            [.C, .D, .D]: .random,
            [.D, .C, .C]: .random,
            [.D, .C, .D]: .random,
            [.D, .D, .C]: .random,
            [.D, .D, .D]: .random,
        ]
        return moveTable
    }
}
