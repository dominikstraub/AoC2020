import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module)

let decks = input
    .components(separatedBy: "\n\n")
    .compactMap { part -> [Int]? in
        if part == "" {
            return nil
        }
        return part.components(separatedBy: "\n")
            .compactMap { line -> Int? in
                if line[..<6] == "Player" {
                    return nil
                }
                return Int(line)
            }
    }

print(decks)

func part1() -> Int {
    return -1
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
