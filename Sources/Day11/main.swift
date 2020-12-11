import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let area = input
    .components(separatedBy: "\n")
    .map { row -> [Int]? in
        if row == "" {
            return nil
        }
        return row.map { (seat) -> Int in
            if seat == "." {
                return 0
            } else if seat == "L" {
                return 1
            } else if seat == "#" {
                return 2
            }
            return -1
        }
    }
    .compactMap { $0 }

var maxOccupied = -1
var onlyRangeOfOne = true

func seatTaken(area: [[Int]], row: Int, column: Int) -> Bool {
    if row < 0 || row >= area.count || column < 0 || column >= area[row].count {
        return false
    }
    return area[row][column] == 2
}

func stopVisibility(area: [[Int]], row: Int, column: Int) -> Bool {
    if row < 0 || row >= area.count || column < 0 || column >= area[row].count {
        return true
    }
    return area[row][column] == 2 || area[row][column] == 1 || onlyRangeOfOne
}

func visibleOccupiedSeats(area: [[Int]], row: Int, column: Int) -> Int {
    let slopes = [(-1, -1),
                  (-1, 0),
                  (-1, +1),
                  (0, -1),
                  (0, +1),
                  (+1, -1),
                  (+1, 0),
                  (+1, +1)]
    var count = 0
    for slope in slopes {
        var range = 1
        while true {
            if seatTaken(area: area, row: row + range * slope.0, column: column + range * slope.1) {
                count += 1
            }
            if stopVisibility(area: area, row: row + range * slope.0, column: column + range * slope.1) {
                break
            }
            range += 1
        }
    }
    return count
}

func getNextArea(area: [[Int]]) -> [[Int]] {
    var nextArea: [[Int]] = []
    for rowIndex in 0 ..< area.count {
        let row = area[rowIndex]
        if nextArea.count <= rowIndex {
            nextArea.insert([], at: rowIndex)
        }
        for columnIndex in 0 ..< row.count {
            if nextArea[rowIndex].count <= columnIndex {
                nextArea[rowIndex].insert(0, at: columnIndex)
            }
            if area[rowIndex][columnIndex] == 0 {
                continue
            }
            let occupiedSeatsCount = visibleOccupiedSeats(area: area, row: rowIndex, column: columnIndex)
            if occupiedSeatsCount == 0 {
                nextArea[rowIndex][columnIndex] = 2
            } else if occupiedSeatsCount >= maxOccupied {
                nextArea[rowIndex][columnIndex] = 1
            } else {
                nextArea[rowIndex][columnIndex] = area[rowIndex][columnIndex]
            }
        }
    }
    return nextArea
}

func compareArea(lhs: [[Int]], rhs: [[Int]]) -> Bool {
    for rowIndex in 0 ..< area.count {
        let row = area[rowIndex]
        for columnIndex in 0 ..< row.count where lhs[rowIndex][columnIndex] != rhs[rowIndex][columnIndex] {
            return false
        }
    }
    return true
}

func stabilize(area: [[Int]]) -> [[Int]] {
    var area = area
    while true {
        let nextArea = getNextArea(area: area)
        if compareArea(lhs: area, rhs: nextArea) {
            return area
        }
        area = nextArea
    }
}

func countAllSteatsTaken(area: [[Int]]) -> Int {
    var count = 0
    for row in area {
        for column in row where column == 2 {
            count += 1
        }
    }
    return count
}

func part1() -> Int {
    maxOccupied = 4
    onlyRangeOfOne = true
    return countAllSteatsTaken(area: stabilize(area: area))
}

print("Part 1: \(part1())")

func part2() -> Int {
    maxOccupied = 5
    onlyRangeOfOne = false
    return countAllSteatsTaken(area: stabilize(area: area))
}

print("Part 2: \(part2())")
