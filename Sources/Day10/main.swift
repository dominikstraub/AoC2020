import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

var adapters = input
    .components(separatedBy: "\n")
    .map { number -> Int? in
        if number == "" {
            return nil
        }
        return Int(number)
    }
    .compactMap { $0 }
    .sorted()

func part1() -> Int {
    var previousAdapter = 0
    var oneDifferenceCount = 0
    var threeDifferenceCount = 1
    for adapter in adapters {
        let difference = adapter - previousAdapter
        previousAdapter = adapter
        if difference == 1 {
            oneDifferenceCount += 1
        } else if difference == 3 {
            threeDifferenceCount += 1
        }
    }
    return oneDifferenceCount * threeDifferenceCount
}

print("Part 1: \(part1())")

adapters.insert(0, at: 0)
let builtin = adapters[adapters.count - 1] + 3
adapters.append(builtin)
var compatibilityMap: [Int: [Int]] = [:]
var countMap: [Int: Int] = [builtin: 1]

func getVariations(current: Int) -> Int {
    if countMap[current] != nil {
        return countMap[current]!
    } else {
        let nexts = compatibilityMap[current]!
        let count = nexts.reduce(0) { $0 + getVariations(current: $1) }
        countMap[current] = count
        return count
    }
}

func part2() -> Int {
    for index in 0 ..< adapters.count {
        for nextIndex in index + 1 ..< adapters.count {
            if adapters[nextIndex] - adapters[index] <= 3 {
                compatibilityMap[adapters[index]] = compatibilityMap[adapters[index]] ?? []
                compatibilityMap[adapters[index]]?.append(adapters[nextIndex])
            } else {
                break
            }
        }
    }
    return getVariations(current: 0)
}

print("Part 2: \(part2())")
