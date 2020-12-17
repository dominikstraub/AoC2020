import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "input")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test")

let lines = input.components(separatedBy: "\n")
    .map { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }
    .compactMap { $0 }

var coords: [Int: [Int: [Int: [Int: Bool]]]] = [0: [0: [:]]]
for lineIndex in 0 ..< lines.count {
    let line = lines[lineIndex]
    var map: [Int: Bool] = [:]
    for columnIndex in 0 ..< line.count {
        map[columnIndex] = Bool(line[columnIndex] == "#")
    }
    coords[0]![0]![lineIndex] = map
}

func getMin(_ w: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: [Int: [Int: Bool]]] {
    var cube = coords[w]
    if cube == nil {
        for (_, currentCube) in coords {
            if cube == nil || cube!.keys.min()! > currentCube.keys.min()! {
                cube = currentCube
            }
        }
    }
    return cube!
}

func getMax(_ w: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: [Int: [Int: Bool]]] {
    var cube = coords[w]
    if cube == nil {
        for (_, currentCube) in coords {
            if cube == nil || cube!.keys.max()! < currentCube.keys.max()! {
                cube = currentCube
            }
        }
    }
    return cube!
}

func getMin(_ w: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    return getMin(w, coords).keys.min()!
}

func getMax(_ w: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    return getMax(w, coords).keys.max()!
}

func getMin(_ w: Int, _ z: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: [Int: Bool]] {
    let cube: [Int: [Int: [Int: Bool]]] = getMin(w, coords)
    var plane = cube[z]
    if plane == nil {
        for (_, currentPlane) in cube {
            if plane == nil || plane!.keys.min()! > currentPlane.keys.min()! {
                plane = currentPlane
            }
        }
    }
    return plane!
}

func getMax(_ w: Int, _ z: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: [Int: Bool]] {
    let cube: [Int: [Int: [Int: Bool]]] = getMax(w, coords)
    var plane = cube[z]
    if plane == nil {
        for (_, currentPlane) in cube {
            if plane == nil || plane!.keys.max()! < currentPlane.keys.max()! {
                plane = currentPlane
            }
        }
    }
    return plane!
}

func getMin(_ w: Int, _ z: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    return getMin(w, z, coords).keys.min()!
}

func getMax(_ w: Int, _ z: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    return getMax(w, z, coords).keys.max()!
}

func getMin(_ w: Int, _ z: Int, _ y: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: Bool] {
    let plane: [Int: [Int: Bool]] = getMin(w, z, coords)
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

func getMax(_ w: Int, _ z: Int, _ y: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: Bool] {
    let plane: [Int: [Int: Bool]] = getMax(w, z, coords)
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

func getMin(_ w: Int, _ z: Int, _ y: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    return getMin(w, z, y, coords).keys.min()!
}

func getMax(_ w: Int, _ z: Int, _ y: Int, _ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    return getMax(w, z, y, coords).keys.max()!
}

func activeNeighbors(_ coords: [Int: [Int: [Int: [Int: Bool]]]], _ w: Int, _ z: Int, _ y: Int, _ x: Int) -> Int {
    let slopes = [
        (-1, -1, -1, -1),
        (-1, -1, -1, 0),
        (-1, -1, -1, +1),
        (-1, -1, 0, -1),
        (-1, -1, 0, 0),
        (-1, -1, 0, +1),
        (-1, -1, +1, -1),
        (-1, -1, +1, 0),
        (-1, -1, +1, +1),
        (-1, 0, -1, -1),
        (-1, 0, -1, 0),
        (-1, 0, -1, +1),
        (-1, 0, 0, -1),
        (-1, 0, 0, 0),
        (-1, 0, 0, +1),
        (-1, 0, +1, -1),
        (-1, 0, +1, 0),
        (-1, 0, +1, +1),
        (-1, +1, -1, -1),
        (-1, +1, -1, 0),
        (-1, +1, -1, +1),
        (-1, +1, 0, -1),
        (-1, +1, 0, 0),
        (-1, +1, 0, +1),
        (-1, +1, +1, -1),
        (-1, +1, +1, 0),
        (-1, +1, +1, +1),
        (0, -1, -1, -1),
        (0, -1, -1, 0),
        (0, -1, -1, +1),
        (0, -1, 0, -1),
        (0, -1, 0, 0),
        (0, -1, 0, +1),
        (0, -1, +1, -1),
        (0, -1, +1, 0),
        (0, -1, +1, +1),
        (0, 0, -1, -1),
        (0, 0, -1, 0),
        (0, 0, -1, +1),
        (0, 0, 0, -1),
        (0, 0, 0, +1),
        (0, 0, +1, -1),
        (0, 0, +1, 0),
        (0, 0, +1, +1),
        (0, +1, -1, -1),
        (0, +1, -1, 0),
        (0, +1, -1, +1),
        (0, +1, 0, -1),
        (0, +1, 0, 0),
        (0, +1, 0, +1),
        (0, +1, +1, -1),
        (0, +1, +1, 0),
        (0, +1, +1, +1),
        (+1, -1, -1, -1),
        (+1, -1, -1, 0),
        (+1, -1, -1, +1),
        (+1, -1, 0, -1),
        (+1, -1, 0, 0),
        (+1, -1, 0, +1),
        (+1, -1, +1, -1),
        (+1, -1, +1, 0),
        (+1, -1, +1, +1),
        (+1, 0, -1, -1),
        (+1, 0, -1, 0),
        (+1, 0, -1, +1),
        (+1, 0, 0, -1),
        (+1, 0, 0, 0),
        (+1, 0, 0, +1),
        (+1, 0, +1, -1),
        (+1, 0, +1, 0),
        (+1, 0, +1, +1),
        (+1, +1, -1, -1),
        (+1, +1, -1, 0),
        (+1, +1, -1, +1),
        (+1, +1, 0, -1),
        (+1, +1, 0, 0),
        (+1, +1, 0, +1),
        (+1, +1, +1, -1),
        (+1, +1, +1, 0),
        (+1, +1, +1, +1),
    ]
    return slopes.reduce(0) { $0 + (coords[w + $1.0]?[z + $1.1]?[y + $1.2]?[x + $1.3] == true ? 1 : 0) }
}

func setCube(_ coords: [Int: [Int: [Int: [Int: Bool]]]], _ w: Int, _ z: Int, _ y: Int, _ x: Int, _ active: Bool) -> [Int: [Int: [Int: [Int: Bool]]]] {
    // if !active, coords[w]?[z]?[y]?[x] != true { return coords }
    var coords = coords
    if coords[w] == nil {
        coords[w] = [:]
    }
    if coords[w]![z] == nil {
        coords[w]![z] = [:]
    }
    if coords[w]![z]![y] == nil {
        coords[w]![z]![y] = [:]
    }
    coords[w]![z]![y]![x] = active
    return coords
}

func nextState(_ coords: [Int: [Int: [Int: [Int: Bool]]]], _ w: Int, _ z: Int, _ y: Int, _ x: Int) -> Bool {
    let neighbors = activeNeighbors(coords, w, z, y, x)
    let active = coords[w]?[z]?[y]?[x] == true
    return (active && (neighbors == 2 || neighbors == 3)) || (!active && neighbors == 3)
}

// func copyCoords(_ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: [Int: [Int: [Int: Bool]]]] {
//     var newCoords: [Int: [Int: [Int: [Int: Bool]]]] = [:]
//     for (wIndex, _) in coords {
//         if newCoords[wIndex] == nil {
//             newCoords[wIndex] = [:]
//         }
//         for (zIndex, _) in coords {
//             if newCoords[wIndex]![zIndex] == nil {
//                 newCoords[wIndex]![zIndex] = [:]
//             }
//             for (yIndex, _) in coords[wIndex]![zIndex]! {
//                 if newCoords[wIndex]![zIndex]![yIndex] == nil {
//                     newCoords[wIndex]![zIndex]![yIndex] = [:]
//                 }

//                 for (xIndex, _) in coords[wIndex]![zIndex]![yIndex]! {
//                     newCoords[wIndex]![zIndex]![yIndex]![xIndex] = coords[wIndex]![zIndex]![yIndex]![xIndex]
//                 }
//             }
//         }
//     }
//     return newCoords
// }

func runCycle(_ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> [Int: [Int: [Int: [Int: Bool]]]] {
    // var nextCoords: [Int: [Int: [Int: [Int: Bool]]]] = copyCoords(coords)
    var nextCoords: [Int: [Int: [Int: [Int: Bool]]]] = [:]
    for wIndex in coords.keys.min()! - 1 ... coords.keys.max()! + 1 {
        for zIndex in getMin(wIndex, coords) - 1 ... getMax(wIndex, coords) + 1 {
            for yIndex in getMin(wIndex, zIndex, coords) - 1 ... getMax(wIndex, zIndex, coords) + 1 {
                for xIndex in getMin(wIndex, zIndex, yIndex, coords) - 1 ... getMax(wIndex, zIndex, yIndex, coords) + 1 {
                    nextCoords = setCube(nextCoords, wIndex, zIndex, yIndex, xIndex, nextState(coords, wIndex, zIndex, yIndex, xIndex))
                }
            }
        }
    }
    return nextCoords
}

func countActive(_ coords: [Int: [Int: [Int: [Int: Bool]]]]) -> Int {
    var count = 0
    for (wIndex, _) in coords {
        for (zIndex, _) in coords {
            for (yIndex, _) in coords[wIndex]![zIndex]! {
                for (xIndex, _) in coords[wIndex]![zIndex]![yIndex]! where coords[wIndex]![zIndex]![yIndex]![xIndex]! {
                    count += 1
                }
            }
        }
    }
    return count
}

// func print(_ coords: [Int: [Int: [Int: [Int: Bool]]]]) {
//     for wIndex in coords.keys.min()! ... coords.keys.max()! {
//         for zIndex in getMin(wIndex, coords) - 1 ... getMax(wIndex, coords) + 1 {
//             print("z=\(zIndex), w=\(wIndex)")
//             for yIndex in getMin(wIndex, zIndex, coords) ... getMax(wIndex, zIndex, coords) {
//                 for xIndex in getMin(wIndex, zIndex, yIndex, coords) ... getMax(wIndex, zIndex, yIndex, coords) {
//                     let value = coords[wIndex]?[zIndex]?[yIndex]?[xIndex]
//                     var char = " "
//                     if value == true {
//                         char = "#"
//                     }
//                     if value == false {
//                         char = "."
//                     }
//                     print(char, terminator: "")
//                 }
//                 print("")
//             }
//             print("")
//         }
//     }
// }

func part2() -> Int {
    // print("Before any cycles:")
    // print("")
    // print(coords)
    // print(countActive(coords))
    for _ in 0 ..< 6 {
        coords = runCycle(coords)
        // print("")
        // print("")
        // print("After \(cycle + 1) cycle:")
        // print("")
        // print(coords)
        // print(countActive(coords))
    }
    return countActive(coords)
}

print("Part 2: \(part2())")
