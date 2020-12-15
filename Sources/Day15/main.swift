import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let numbers = input
    .components(separatedBy: CharacterSet(charactersIn: ",\n"))
    .map { number -> Int? in
        if number == "" {
            return nil
        }
        return Int(number)
    }
    .compactMap { $0 }

func get(nthNumber max: Int) -> Int {
    var pastNumbers: [Int: Int] = [:]
    var lastNumber = -1
    var lastIndex = -1
    var nextIndex = 0
    for (index, number) in numbers.enumerated() {
        if lastNumber != -1 {
            pastNumbers[lastNumber] = lastIndex
        }
        lastIndex = index
        lastNumber = number
        nextIndex += 1
    }
    var nextNumber = 0
    while nextIndex < max {
        nextNumber = pastNumbers[lastNumber] == nil ? 0 : nextIndex - 1 - pastNumbers[lastNumber]!
        pastNumbers[lastNumber] = lastIndex
        lastIndex = nextIndex
        lastNumber = nextNumber
        nextIndex += 1
    }
    return lastNumber
}

print("Part 1: \(get(nthNumber: 2020))")

print("Part 2: \(get(nthNumber: 30_000_000))")
