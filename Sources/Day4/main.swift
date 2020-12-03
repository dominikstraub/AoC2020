import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let items = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { $0 }

func part1(items: [String]) -> Int {
    return -1
}

print("Part 1: \(part1(items: items))")

func part2(items: [String]) -> Int {
    return -1
}

print("Part 2: \(part2(items: items))")
