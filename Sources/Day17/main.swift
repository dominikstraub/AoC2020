import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "input")
let input = try Utils.getInput(bundle: Bundle.module, file: "test")

let lines = input.components(separatedBy: "\n")
    .map { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }
    .compactMap { $0 }

var grid: [Int: [Int: [Int: Bool]]] = [0: [:]]
for lineIndex in 0 ..< lines.count {
    let line = lines[lineIndex]
    var map: [Int: Bool] = [:]
    for columnIndex in 0 ..< line.count {
        map[columnIndex] = Bool(line[columnIndex] == "#")
    }
    grid[0]![lineIndex] = map
}

func activeNeighbors(_ grid: [Int: [Int: [Int: Bool]]], _ z: Int, _ y: Int, _ x: Int) -> Int {
    let slopes = [
        (-1, -1, -1),
        (-1, -1, 0),
        (-1, -1, +1),
        (-1, 0, -1),
        (-1, 0, 0),
        (-1, 0, +1),
        (-1, +1, -1),
        (-1, +1, 0),
        (-1, +1, +1),
        (0, -1, -1),
        (0, -1, 0),
        (0, -1, +1),
        (0, 0, -1),
        (0, 0, +1),
        (0, +1, -1),
        (0, +1, 0),
        (0, +1, +1),
        (+1, -1, -1),
        (+1, -1, 0),
        (+1, -1, +1),
        (+1, 0, -1),
        (+1, 0, 0),
        (+1, 0, +1),
        (+1, +1, -1),
        (+1, +1, 0),
        (+1, +1, +1),
    ]
    return slopes.reduce(0) { $0 + (grid[z + $1.0]?[y + $1.1]?[x + $1.2] == true ? 1 : 0) }
}

func setCube(_ grid: [Int: [Int: [Int: Bool]]], _ z: Int, _ y: Int, _ x: Int, _ active: Bool) -> [Int: [Int: [Int: Bool]]] {
    if !active, grid[z]?[y]?[x] != true { return grid }
    var grid = grid
    if grid[z] == nil {
        grid[z] = [:]
    }
    if grid[z]![y] == nil {
        grid[z]![y] = [:]
    }
    grid[z]![y]![x] = active
    return grid
}

func nextState(_ grid: [Int: [Int: [Int: Bool]]], _ z: Int, _ y: Int, _ x: Int) -> Bool {
    let neighbors = activeNeighbors(grid, z, y, x)
    let active = grid[z]?[y]?[x] == true
    return (active && (neighbors == 2 || neighbors == 3)) || (!active && neighbors == 3)
}

func getMin(_ z: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> [Int: [Int: Bool]] {
    var plane = grid[z]
    if plane == nil {
        for (_, currentPlane) in grid {
            if plane == nil || plane!.keys.min()! > currentPlane.keys.min()! {
                plane = currentPlane
            }
        }
    }
    return plane!
}

func getMax(_ z: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> [Int: [Int: Bool]] {
    var plane = grid[z]
    if plane == nil {
        for (_, currentPlane) in grid {
            if plane == nil || plane!.keys.max()! < currentPlane.keys.max()! {
                plane = currentPlane
            }
        }
    }
    return plane!
}

func getMin(_ z: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> Int {
    return getMin(z, grid).keys.min()!
}

func getMax(_ z: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> Int {
    return getMax(z, grid).keys.max()!
}

func getMin(_ z: Int, _ y: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> [Int: Bool] {
    let plane: [Int: [Int: Bool]] = getMin(z, grid)
    var line = plane[y]
    if line == nil {
        for (_, currentPlane) in plane {
            if line == nil || line!.keys.min()! > currentPlane.keys.min()! {
                line = currentPlane
            }
        }
    }
    return line!
}

func getMax(_ z: Int, _ y: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> [Int: Bool] {
    let plane: [Int: [Int: Bool]] = getMax(z, grid)
    var line = plane[y]
    if line == nil {
        for (_, currentPlane) in plane {
            if line == nil || line!.keys.max()! < currentPlane.keys.max()! {
                line = currentPlane
            }
        }
    }
    return line!
}

func getMin(_ z: Int, _ y: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> Int {
    return getMin(z, y, grid).keys.min()!
}

func getMax(_ z: Int, _ y: Int, _ grid: [Int: [Int: [Int: Bool]]]) -> Int {
    return getMax(z, y, grid).keys.max()!
}

func runCycle(_ grid: [Int: [Int: [Int: Bool]]]) -> [Int: [Int: [Int: Bool]]] {
    var nextGrid: [Int: [Int: [Int: Bool]]] = [:]
    for zIndex in grid.keys.min()! - 1 ... grid.keys.max()! + 1 {
        for yIndex in getMin(zIndex, grid) - 1 ... getMax(zIndex, grid) + 1 {
            for xIndex in getMin(zIndex, yIndex, grid) - 1 ... getMax(zIndex, yIndex, grid) + 1 {
                nextGrid = setCube(nextGrid, zIndex, yIndex, xIndex, nextState(grid, zIndex, yIndex, xIndex))
            }
        }
    }
    return nextGrid
}

func countActive(_ grid: [Int: [Int: [Int: Bool]]]) -> Int {
    var count = 0
    for (zIndex, _) in grid {
        for (yIndex, _) in grid[zIndex]! {
            for (xIndex, _) in grid[zIndex]![yIndex]! {
                if grid[zIndex]![yIndex]![xIndex]! {
                    count += 1
                }
            }
        }
    }
    return count
}

func print(_ grid: [Int: [Int: [Int: Bool]]]) {
    for zIndex in grid.keys.min()! ... grid.keys.max()! {
        print("z=\(zIndex)")
        for yIndex in getMin(zIndex, grid) ... getMax(zIndex, grid) {
            for xIndex in getMin(zIndex, yIndex, grid) ... getMax(zIndex, yIndex, grid) {
                let value = grid[zIndex]?[yIndex]?[xIndex]
                var char = " "
                if value == true {
                    char = "#"
                }
                if value == false {
                    char = "."
                }
                print(char, terminator: "")
            }
            print("")
        }
        print("")
    }
}

func part1() -> Int {
    print("Before any cycles:")
    print("")
    print(grid)
    print(countActive(grid))
    for cycle in 0 ..< 6 {
        grid = runCycle(grid)
        print("")
        print("")
        print("After \(cycle + 1) cycle:")
        print("")
        print(grid)
        print(countActive(grid))
    }
    return countActive(grid)
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
