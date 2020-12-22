import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module)

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

typealias Row = [Bool]
typealias TileData = [Row]
typealias Border = [Bool]
typealias ImageData = [Int: [Int: Bool]]

class Tile: CustomStringConvertible {
    let id: Int
    let data: TileData
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
        var newData: TileData = []
        for (y, row) in data.enumerated() {
            newData.insert([], at: y)
            for (x, _) in row.enumerated() {
                newData[y].insert(data[data.count - 1 - x][y], at: x)
            }
        }
        return Tile(tile: self, data: newData).rotated(times: times - 1)
    }

    func getMutations() -> [Tile] {
        return [self, flippedH(), flippedV()]
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

    func matching(tile: Tile) {
        for selfBorder in getMutations().flatMap({ $0.getBorders() }) {
            for border in tile.getMutations().flatMap({ $0.getBorders() }) where selfBorder == border {
                matchingTiles[tile.id] = tile
                tile.matchingTiles[id] = self
                return
            }
        }
    }

    func matches(tile: Tile) -> Tile? {
        for selfBorder in getBorders() {
            for mutation in tile.getMutations() {
                for boder in mutation.getBorders() where selfBorder == boder {
                    return mutation
                }
            }
        }
        return nil
    }

    init(lines: [String]) {
        id = Int(lines[0].components(separatedBy: CharacterSet(charactersIn: " :"))[1])!
        data = lines[1...].map { $0.map { $0 == "#" }}
    }

    init(tile: Tile, data: TileData) {
        id = tile.id
        self.data = data
    }

    public var description: String {
        "\(id)"
    }
}

class Image: CustomStringConvertible {
    var tiles: [Int: [Int: Tile]] = [:]
    var data: ImageData = [:]

    func updateData() {
        for (tileY, tileRow) in tiles {
            for (tileX, tile) in tileRow {
                for (y, row) in tile.data.enumerated() {
                    if y == 0 || y == tile.data.count - 1 { continue }
                    let newY = tileY * (tile.data.count - 2) + y - 1
                    if data[newY] == nil {
                        data[newY] = [:]
                    }
                    for (x, pixel) in row.enumerated() {
                        if x == 0 || x == row.count - 1 { continue }
                        let newX = tileX * (row.count - 2) + x - 1
                        data[newY]![newX] = pixel
                    }
                }
            }
        }
    }

    func print() {
        for (_, row) in data {
            for (_, pixel) in row {
                Swift.print(pixel ? "#" : ".", terminator: "")
            }
            Swift.print("")
        }
    }

    func flippedH() -> Image {
        var newData: ImageData = [:]
        for (y, row) in data {
            newData[y] = [:]
            for (x, _) in row {
                newData[y]![x] = data[y]![row.count - x - 1]
            }
        }
        return Image(data: newData)
    }

    func flippedV() -> Image {
        var newData: ImageData = [:]
        for (y, _) in data {
            newData[y] = data[data.count - y - 1]
        }
        return Image(data: newData)
    }

    /**
     * @brief      rotate clock wise
     */
    func rotated(times: Int = 1) -> Image {
        if times == 0 {
            return self
        }
        var newData: ImageData = [:]
        for (y, row) in data {
            newData[y] = [:]
            for (x, _) in row {
                newData[y]![x] = data[data.count - 1 - x]![y]
            }
        }
        return Image(data: newData).rotated(times: times - 1)
    }

    func getMutations() -> [Image] {
        return [self, flippedH(), flippedV()]
    }

    init() {}

    init(data: ImageData) {
        self.data = data
    }

    public var description: String {
        "\(tiles)"
    }
}

// func part1() -> Int {
//     for tile in tiles {
//         for tile2 in tiles where tile.id != tile2.id {
//             tile.matching(tile: tile2)
//         }
//     }

//     var sum = 1
//     for tile in tiles {
//         if tile.matchingTiles.count == 2 {
//             sum *= tile.id
//         }
//     }
//     return sum
// }

// print("Part 1: \(part1())")

func part2() -> Int {
    for tile in tiles {
        for tile2 in tiles where tile.id != tile2.id {
            tile.matching(tile: tile2)
        }
    }

    let image = Image()
    for tile in tiles where tile.matchingTiles.count == 2 {
        image.tiles[0] = [0: tile]
        break
    }
    let sideLength = Int(Double(tiles.count).squareRoot())
    for y in 0 ..< sideLength {
        if image.tiles[y] == nil {
            let tile = image.tiles[y - 1]![0]!.matchingTiles.filter { id, _ in
                if y > 1, id == image.tiles[y - 2]![0]!.id { return false }
                if id == image.tiles[y - 1]![1]!.id { return false }
                return true
            }.first!.value
            image.tiles[y] = [0: tile]
        }
        for x in 1 ..< sideLength {
            let tile = image.tiles[y]![x - 1]!.matchingTiles.filter { id, _ in
                if y > 0, id == image.tiles[y - 1]![x - 1]!.id { return false }
                if y > 0, !image.tiles[y - 1]![x]!.matchingTiles.contains(where: { $0.key == id }) { return false }
                if x > 1, id == image.tiles[y]![x - 2]!.id { return false }
                return true
            }.first!.value
            image.tiles[y]![x] = tile
        }
    }

    for y in 0 ..< sideLength {
        if y > 0 {
            image.tiles[y]![0] = image.tiles[y - 1]![0]!.matches(tile: image.tiles[y]![0]!)
        }
        for x in 1 ..< sideLength {
            image.tiles[y]![x] = image.tiles[y]![x - 1]!.matches(tile: image.tiles[y]![x]!)
        }
    }

    image.updateData()
    image.print()

    return -1
}

print("Part 2: \(part2())")
