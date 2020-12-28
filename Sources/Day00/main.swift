import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }

func part1() -> Int {
    return -1
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
