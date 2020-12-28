import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module)

let cups = input
    .components(separatedBy: "\n")[0]
    .compactMap { Int(String($0)) }

print(cups)

func part1() -> Int {
    return -1
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
