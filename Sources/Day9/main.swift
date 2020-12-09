import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let numbers = input
    .components(separatedBy: "\n")
    .map { number -> Int? in
        if number == "" {
            return nil
        }
        return Int(number)
    }
    .compactMap { $0 }

func getInvalidNumber(preambleLength: Int = 25) -> Int {
    for index in preambleLength ..< numbers.count {
        var found = false
        for lowerIndex in index - preambleLength ..< index - 1 {
            for upperIndex in (index - preambleLength) + 1 ..< index {
                if lowerIndex == upperIndex {
                    continue
                }
                if numbers[index] == numbers[lowerIndex] + numbers[upperIndex] {
                    found = true
                    break
                }
            }
            if found {
                break
            }
        }
        if !found {
            return numbers[index]
        }
    }
    return -1
}

func part1() -> Int {
    return getInvalidNumber()
}

print("Part 1: \(part1())")

func part2() -> Int {
    let invalidNumber = getInvalidNumber()
    for lowerIndex in 0 ..< numbers.count - 1 {
        for upperIndex in lowerIndex + 1 ..< numbers.count {
            if upperIndex - lowerIndex < 1 {
                continue
            }
            let slice = numbers[lowerIndex ... upperIndex]
            if slice.reduce(0, +) == invalidNumber {
                return slice.min()! + slice.max()!
            }
        }
    }
    return -1
}

print("Part 2: \(part2())")
