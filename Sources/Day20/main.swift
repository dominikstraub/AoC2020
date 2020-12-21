import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let tiles = input.components(separatedBy: "\n\n")
    .map { tile -> Tile in
        let lines: [String] = tile.components(separatedBy: "\n").compactMap {
            if $0 == "" {
                return nil
            }
            return $0
        }
        return Tile(lines: lines)
    }

print(tiles)

typealias Row = [Bool]
typealias ImageData = [Row]
typealias Border = [Bool]

class Tile: CustomStringConvertible {
    let id: Int
    let data: ImageData
    var matchingTiles: [Int: Tile] = [:]

    func flippedH() -> Tile {
        Tile(tile: self, data: data.map { $0.reversed() })
    }

    func flippedV() -> Tile {
        Tile(tile: self, data: data.reversed())
    }

    /**
     * @brief      rotate clock wise
     */
    func rotated(times: Int = 1) -> Tile {
        if times == 0 {
            return self
        }
        var newData: ImageData = []
        for (y, row) in data.enumerated() {
            newData.insert([], at: y)
            for (x, _) in row.enumerated() {
                newData[y].insert(data[data.count - 1 - x][y], at: x)
            }
        }
        return Tile(tile: self, data: newData).rotated(times: times - 1)
    }

    func getMutations() -> [Tile] {
        return [
            self, flippedH(), flippedV(),
        ]
    }

    func getTopBorder() -> Border {
        data.first!
    }

    func getRightBorder() -> Border {
        data.map { $0.last! }
    }

    func getBottomBorder() -> Border {
        data.last!
    }

    func getLeftBorder() -> Border {
        data.map { $0.first! }
    }

    func getBorders() -> [Border] {
        [getTopBorder(), getRightBorder(), getBottomBorder(), getLeftBorder()]
    }

    func matches(tile: Tile) -> Bool {
        for selfBorder in getMutations().flatMap({ $0.getBorders() }) {
            for border in tile.getMutations().flatMap({ $0.getBorders() }) where selfBorder == border {
                matchingTiles[tile.id] = tile
                tile.matchingTiles[id] = self
                return true
            }
        }
        return false
    }

    init(lines: [String]) {
        id = Int(lines[0].components(separatedBy: CharacterSet(charactersIn: " :"))[1])!
        data = lines[1...].map { $0.map { $0 == "#" }}
    }

    init(tile: Tile, data: ImageData) {
        id = tile.id
        self.data = data
    }

    public var description: String {
        "\(id)"
    }
}

func part1() -> Int {
    for tile in tiles {
        for tile2 in tiles where tile.id != tile2.id {
            _ = tile.matches(tile: tile2)
        }
    }

    var sum = 1
    for tile in tiles {
        if tile.matchingTiles.count == 2 {
            sum *= tile.id
        }
        print(tile.matchingTiles)
    }
    return sum
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
