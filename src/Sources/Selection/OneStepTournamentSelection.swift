//
//  OneStepTournamentSelection.swift
//
//  Created by nicosrm
//

import Foundation

/// Two-step tournament selection selecting for each strategy
/// ``directTournamentCount`` times random opponents to play against. After the
/// whole population played against random strategies, select the
/// ``selectionCount`` best (Weicker, 2024).
class OneStepTournamentSelection: SelectionProtocol {
    
    let population: [GeneticStrategy]
    let selectionCount: Int
    
    let directTournamentCount: Int
    let matchIterationCount: Int
    
    required init(
        population: [GeneticStrategy],
        selectionCount: Int,
        directTournierCount: Int,
        matchIterationCount: Int
    ) {
        self.population = population
        self.selectionCount = selectionCount
        self.directTournamentCount = directTournierCount
        self.matchIterationCount = matchIterationCount
    }
    
    func select() -> [(GeneticStrategy, Int)] {
        log.log("Playing tournament...")
        let wins = self.playTournament()
        log.log("Wins: \(wins)")
        
        log.log("Selecting...")
        let selection = self.select(from: wins)
        log.log("Selected \(selection.count) strategies")
        log.log("with wins: \(selection.map { $0.wins })")
        return selection
    }
}

private extension OneStepTournamentSelection {
    
    func select(from wins: [Int]) -> [(strategy: GeneticStrategy, wins: Int)] {
        let zip = Array(zip(self.population, wins))
        
        // sort by score
        let sorted = zip.sorted { $0.1 > $1.1 }
        let selection = sorted.prefix(self.selectionCount)
        
        return Array(selection)
    }
    
    func playTournament() -> [Int] {
        var scores = [Int]()
        
        for playerA in self.population {
            var wins = 0
            
            for _ in 2...self.directTournamentCount {
                let playerB = self.population.randomElement()!
                let scorePair = self.playMatch(playerA, against: playerB)
                if scorePair.A > scorePair.B {
                    wins += 1
                }
            }
            scores.append(wins)
        }
        
        return scores
    }
    
    func playMatch(
        _ playerA: GeneticStrategy,
        against playerB: GeneticStrategy
    ) -> ScoreHelper.ScorePair {
        let match = Match(
            playerA: playerA,
            playerB: playerB,
            turns: self.matchIterationCount
        )
        match.play()
        return match.game.score
    }
}
