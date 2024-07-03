//
//  GeneticStrategy.swift
//
//  Created by nicosrm
//

import Foundation

/// Strategy usable for evolutionary algorithms.
class GeneticStrategy: StrategyProtocol {
    
    typealias MoveTable = [[Move]: Move]
    
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
    let moveTable: MoveTable
    
    var history: MoveHistory
    
    /// Initialize at least the last 3 moves in `history`.
    required init(
        history: MoveHistory,
        moveTable: [[Move] : Move]? = nil
    ) {
        self.name = "Genetic Strategy"
        self.moveTable = moveTable ?? Self.randomMoveTable
        
        assert(history.count >= 3, "At least 3 initial moves must be specified")
        self.history = history
    }
    
    /// Generate random ``GeneticStrategy``.
    convenience init() {
        let history: [Move] = [.random, .random, .random]
        self.init(history: history)
    }
    
    func makeMove(opponentHistory: MoveHistory) -> Move {
        let lastThreeMoves: [Move] = opponentHistory.suffix(3)
        let move = self.moveTable[lastThreeMoves]!
        self.history.append(move)
        return move
    }
}

// MARK: - Helper functions

extension GeneticStrategy {
    
    /// Clears history except for first three initial moves.
    func clearHistory() {
        self.history = Array(self.history.prefix(3))
    }
    
    /// Random move table.
    /// See ``moveTable`` for the pattern.
    static var randomMoveTable: MoveTable {
        let moveTable: MoveTable = [
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
    
    func copyWith(
        history: MoveHistory? = nil,
        moveTable: MoveTable? = nil
    ) -> Self {
        return .init(
            history: history ?? self.history,
            moveTable: moveTable ?? self.moveTable
        )
    }
    
    /// Print instance of this class. Sort ``moveTable`` first.
    func debugPrint() {
        log.log(self.name)
        
        log.log("moveTable")
        let keys = self.moveTable.keys.sorted()
        for key in keys {
            log.log("\(key) --> \(self.moveTable[key]!)")
        }
        
        log.log("history")
        log.log(self.history)
    }
}
