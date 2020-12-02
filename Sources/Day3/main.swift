import Foundation
import Utils

// let input = try Utils.getInput(day: 3, file: "test.txt")
let input = try Utils.getInput(day: 3)

let items = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { $0 }

print("Part 1: \(part1(items: items))")

print("Part 2: \(part2(items: items))")
