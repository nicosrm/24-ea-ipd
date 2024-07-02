//
//  main.swift
//
//  Created by nicosrm
//

func crossoverExample() {
    let strategyA = GeneticStrategy(history: [.C, .C, .C])
    let strategyB = GeneticStrategy(history: [.C, .C, .C])
    
    print("**Strategy A**")
    strategyA.debugPrint()
    print()
    print("**Strategy B**")
    strategyB.debugPrint()
    print()
    
    let (childA, childB) = OnePointCrossover.crossover(strategyA, strategyB)
//    let (childA, childB) = UniformCrossover.crossover(strategyA, strategyB)
    
    print("**Child A**")
    childA.debugPrint()
    print()
    print("**Child B**")
    childB.debugPrint()
}

func mutationExample() {
    let parent = GeneticStrategy(history: [.C, .C, .C])
    print("**Parent**")
    parent.debugPrint()
    
    print()
    print("**One Flip Mutation**")
    OneFlipMutation().mutate(parent).debugPrint()
    
    print()
    print("**Probabilistic Mutation**")
    ProbabilisticMutation(mutationRate: 0.1).mutate(parent).debugPrint()
}

func tournamentExample() {
    let populationSize = 10
    let tournament = Tournament(populationSize: populationSize, iterationCount: 5)
    tournament.play()
    
    print("**Tournament scores**")
    print(tournament.scores.sorted(by: >))
}

func printDivider() {
    print()
    print(String(repeating: "=", count: 100))
    print()
}

crossoverExample()
printDivider()
mutationExample()
printDivider()
tournamentExample()
