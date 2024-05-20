//
//  GeneticStrategy.swift
//
//  Created by nicosrm
//

import Foundation

/// Strategy usable for evolutionary algorithms.
class GeneticStrategy: StrategyProtocol {
    
    var name: String
    
    /// Answers to opponent's last moves.
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
        moveTable: [[Move] : Move],
        history: MoveHistory
    ) {
        self.name = "Genetic Strategy"
        self.moveTable = moveTable
        
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
        moveTable: [[Move] : Move]? = nil,
        history: MoveHistory?
    ) -> Self {
        return .init(
            moveTable: moveTable ?? self.moveTable,
            history: history ?? self.history
        )
    }
}
