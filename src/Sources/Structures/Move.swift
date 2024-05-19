//
//  Move.swift
//
//  Created by nicosrm
//

import Foundation

enum Move: Int, Hashable, CaseIterable {
    
    /// Cooperate
    case C = 0
    
    /// Defect
    case D = 1
    
    var flip: Self {
        switch self {
        case .C: .D
        case .D: .C
        }
    }
    
    static var random: Self {
        return allCases.randomElement()!
    }
}

struct MovePair: Hashable {
    
    let movePlayerA: Move
    let movePlayerB: Move
    
    init(_ movePlayerA: Move, _ movePlayerB: Move) {
        self.movePlayerA = movePlayerA
        self.movePlayerB = movePlayerB
    }
}
