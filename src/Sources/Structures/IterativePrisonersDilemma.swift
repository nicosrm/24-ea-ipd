//
//  IterativePrisonersDilemma.swift
//
//  Created by nicosrm
//

import Foundation

struct IterativePrisonersDilemma {
    
    let populationSize: Int
    let memoryDepth: Int
    let movesPerGame: Int
    
    let crossoverRate: Double
    let mutationRate: Double
    
    let crossover: any CrossoverProtocol
    let mutator: any MutationProtocol
//    let fitnessCalculator: any FitnessProtocol
    
//    let selectFunction: (Genotype, Genotype) -> Genotype
}
