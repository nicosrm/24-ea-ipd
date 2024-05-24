// The Swift Programming Language
// https://docs.swift.org/swift-book

let strategyA = GeneticStrategy(history: [.C, .C, .C])
let strategyB = GeneticStrategy(history: [.C, .C, .C])

print("strategy A:")
strategyA.debugPrint()
print()
print("strategy B:")
strategyB.debugPrint()
print()

let (childA, childB) = OnePointCrossover.crossover(strategyA, strategyB)

print("child A")
childA.debugPrint()
print()
print("child B")
childB.debugPrint()
