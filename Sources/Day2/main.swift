import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let items = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .map { (item) -> (Int, Int, Character, String)? in
        let parts = item.components(separatedBy: CharacterSet(charactersIn: "- :"))
        if parts.count < 4 { return nil }
        guard let first = Int(parts[0]), let second = Int(parts[1]) else { return nil }
        return (first: first, second: second, letter: Character(parts[2]), password: parts[4])
    }
    .compactMap { $0 }

func part1(items: [(first: Int, second: Int, letter: Character, password: String)]) -> Int {
    var validCount = 0
    for entry in items {
        let letterCount = entry.password.filter { $0 == entry.letter }.count
        if letterCount >= entry.first && letterCount <= entry.second {
            validCount += 1
        }
    }
    return validCount
}

print("Part 1: \(part1(items: items))")

func part2(items: [(first: Int, second: Int, letter: Character, password: String)]) -> Int {
    var validCount = 0
    for entry in items {
        let firstValid = entry.password.count >= entry.first &&
            entry.password[entry.password.index(entry.password.startIndex, offsetBy: entry.first - 1)] == entry.letter
        let secondValid = entry.password.count >= entry.second &&
            entry.password[entry.password.index(entry.password.startIndex, offsetBy: entry.second - 1)] == entry.letter
        if firstValid && !secondValid || !firstValid && secondValid {
            validCount += 1
        }
    }
    return validCount
}

print("Part 2: \(part2(items: items))")
