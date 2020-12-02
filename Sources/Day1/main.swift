import Foundation
import Utils

// let input = try Utils.getInput(day: 1, file: "test.txt")
let input = try Utils.getInput(day: 1)

let items = input
    .components(separatedBy: CharacterSet(charactersIn: ", \n"))
    .map { (item) -> Int? in
        return Int(item)
    }
    .compactMap { $0 }

func part1(items: [Int]) -> Int {
    let length = items.count
    for entry in items {
        for index in 1...length - 1 where entry + items[index] == 2020 {
            return entry * items[index]
        }
    }
    return -1
}

print("Part 1: \(part1(items: items))")

func part2(items: [Int]) -> Int {
    let length = items.count
    for entry in items {
        for index in 1...length - 1 {
            for index2 in 2...length - 1 where entry + items[index] + items[index2] == 2020 {
                return entry * items[index] * items[index2]
            }
        }
    }
    return -1
}

print("Part 2: \(part2(items: items))")
