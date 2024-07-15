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

extension Move: Comparable {
    
    static func < (lhs: Move, rhs: Move) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Move: CustomStringConvertible {
    
    var description: String {
        return switch self {
        case .C: "C"
        case .D: "D"
        }
    }
}

// MARK: - MovePair

struct MovePair: Hashable {
    
    let movePlayerA: Move
    let movePlayerB: Move
    
    init(_ movePlayerA: Move, _ movePlayerB: Move) {
        self.movePlayerA = movePlayerA
        self.movePlayerB = movePlayerB
    }
}

// MARK: - [Move]

extension [Move]: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        let leftValue = convertToBinary(lhs) ?? 0
        let rightValue = convertToBinary(rhs) ?? 0
        return leftValue < rightValue
    }
    
    private static func convertToBinary(_ array: Self) -> Int? {
        var binaryString = ""
        
        for move in array {
            binaryString += String(move.rawValue)
        }
        
        return Int(binaryString, radix: 2)
    }
}

