import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: "\n")
    .compactMap { line -> ([String], [String])? in
        if line == "" {
            return nil
        }
        let parts = line.components(separatedBy: " (contains ")
        let ingredients = parts[0].components(separatedBy: " ")
        let allergens = parts[1].components(separatedBy: CharacterSet(charactersIn: ", )")).compactMap { $0 == "" ? nil : $0 }
        return (ingredients, allergens)
    }

print(lines)

func part1() -> Int {
    return -1
}

print("Part 1: \(part1())")

func part2() -> Int {
    return -1
}

print("Part 2: \(part2())")
