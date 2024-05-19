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
    /// Might be `nil`, e.g. for pre-defined strategies.
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
    // TODO: - Refactor move table --> (Axelrod, 1997)
    
    var history: MoveHistory
    
    required init(
        moveTable: [[Move] : Move],
        history: MoveHistory
    ) {
        self.name = "Genetic Strategy"
        self.moveTable = moveTable
        self.history = history
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let lastThreeMoves: [Move] = opponentHistory.suffix(3)
        
        if let move = self.moveTable[lastThreeMoves] {
            return move
        }
        print(">> failure in GeneticStrategy makeMove")
        print(">> \(lastThreeMoves) not in move table")
        // should not happen
        return .random
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
