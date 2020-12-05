import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let boardingPasses = input
    .components(separatedBy: "\n")
    .compactMap { $0 }

func rowColumn(ofPass pass: String) -> (row: Int, column: Int) {
    var minRow = 0
    var maxRow = 127
    var minColumn = 0
    var maxColumn = 7
    for letter in pass {
        if letter == "F" {
            maxRow = (minRow + maxRow + 1) / 2 - 1
        } else if letter == "B" {
            minRow = (minRow + maxRow + 1) / 2
        } else if letter == "L" {
            maxColumn = (minColumn + maxColumn + 1) / 2 - 1
        } else if letter == "R" {
            minColumn = (minColumn + maxColumn + 1) / 2
        }
    }
    return (row: minRow, column: minColumn)
}

var passes = [Int: Bool]()

func part1(boardingPasses: [String]) -> Int {
    var highestPass = -1
    for pass in boardingPasses {
        let position = rowColumn(ofPass: pass)
        let seatId = position.row * 8 + position.column
        passes[seatId] = true
        if seatId > highestPass {
            highestPass = seatId
        }
    }
    return highestPass
}

print("Part 1: \(part1(boardingPasses: boardingPasses))")

func part2() -> Int {
    for pass in passes {
        if passes[pass.key - 1] != true && passes[pass.key - 2] == true {
            return pass.key - 1
        }
        if passes[pass.key + 1] != true && passes[pass.key + 2] == true {
            return pass.key + 1
        }
    }
    return -1
}

print("Part 2: \(part2())")
