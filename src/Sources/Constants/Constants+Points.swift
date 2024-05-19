//
//  Rules.swift
//
//  Created by nicosrm
//

import Foundation

extension Constants {
    
    struct Points {
                
        /// Points when both cooperate
        static let reward = 3;
        
        /// Points when both defect
        static let punishment = 1;
        
        /// Points for cooperation when opponent defects
        static let sucker = 0;
        
        /// Points for defection when opponent cooperates
        static let temptation = 5
        
        /// Points for each possible move pair
        static let payoffMatrix = [
            MovePair(.C, .C): (reward, reward),
            MovePair(.C, .D): (sucker, temptation),
            MovePair(.D, .C): (temptation, sucker),
            MovePair(.D, .D): (punishment, punishment),
        ]
    }
}
