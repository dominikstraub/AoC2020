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

    func getMutations(withRotation: Bool = false) -> [Tile] {
        if withRotation {
            let rotatedTile = rotated()
            return [
                self, flippedH(), flippedV(), flippedH().flippedV(),
                rotatedTile, rotatedTile.flippedH(), rotatedTile.flippedV(), rotatedTile.flippedH().flippedV(),
            ]
        } else {
            return [self, flippedH(), flippedV()]
        }
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

    func matches(border selfBorder: Border, borderFunction: (Tile) -> () -> Border) -> Tile? {
        for mutation in getMutations(withRotation: true) {
            if selfBorder == borderFunction(mutation)() {
                // print("found")
                return mutation
            }
        }
        // print("not found")
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
        var string = ""
        for y in 0 ..< data.count {
            for x in 0 ..< data[y].count {
                string.append(data[y][x] ? "#" : ".")
            }
            string.append("\n")
        }
        return string
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
        let rotatedTile = rotated()
        return [
            self, flippedH(), flippedV(), flippedH().flippedV(),
            rotatedTile, rotatedTile.flippedH(), rotatedTile.flippedV(), rotatedTile.flippedH().flippedV(),
        ]
    }

    func findSeeMonsters() -> [(Int, Int)] {
        var monsters: [(Int, Int)] = []
        for (y, row) in data {
            for (x, _) in row {
                if findSeeMonster(y: y, x: x) {
                    monsters.append((y, x))
                }
            }
        }
        return monsters
    }

    /**
     * @brief      Finds a see monster.
     *  01234567890123456789
     * 0                  #
     * 1#    ##    ##    ###
     * 2 #  #  #  #  #  #
     *
     * 0                  14
     * 10    34    78    111213
     * 2 1  2  5  6  9  10
     *
     * @param      y     origin y
     * @param      x     origin x
     *
     * @return     Bool
     */
    func findSeeMonster(y: Int, x: Int) -> Bool {
        guard data.count > y + 2, data[y]!.count > x + 19 else { return false }
        return
            data[y]![x + 18]! &&

            data[y + 1]![x]! &&
            data[y + 1]![x + 5]! &&
            data[y + 1]![x + 6]! &&
            data[y + 1]![x + 11]! &&
            data[y + 1]![x + 12]! &&
            data[y + 1]![x + 17]! &&
            data[y + 1]![x + 18]! &&
            data[y + 1]![x + 19]! &&

            data[y + 2]![x + 1]! &&
            data[y + 2]![x + 4]! &&
            data[y + 2]![x + 7]! &&
            data[y + 2]![x + 10]! &&
            data[y + 2]![x + 13]! &&
            data[y + 2]![x + 16]!
    }

    func waterCount() -> Int {
        var count = 0
        for (_, row) in data {
            for (_, pixel) in row where pixel {
                count += 1
            }
        }
        return count
    }

    init() {}

    init(data: ImageData) {
        self.data = data
    }

    public var description: String {
        var string = ""
        for y in 0 ..< data.count {
            for x in 0 ..< data[y]!.count {
                string.append(data[y]![x]! ? "#" : ".")
            }
            string.append("\n")
        }
        return string
    }
}

func part1() -> Int {
    for tile in tiles {
        for tile2 in tiles where tile.id != tile2.id {
            tile.matching(tile: tile2)
        }
    }

    var sum = 1
    for tile in tiles {
        if tile.matchingTiles.count == 2 {
            sum *= tile.id
        }
    }
    return sum
}

print("Part 1: \(part1())")

func part2() -> Int {
    for tile in tiles {
        for tile2 in tiles where tile.id != tile2.id {
            tile.matching(tile: tile2)
        }
    }

    var image = Image()
    for tile in tiles where tile.matchingTiles.count == 2 {
        image.tiles[0] = [0: tile]
        break
    }
    let sideLength = Int(Double(tiles.count).squareRoot())
    for y in 0 ..< sideLength {
        if image.tiles[y] == nil {
            let tile = image.tiles[y - 1]![0]!.matchingTiles.filter { id, tile in
                if y > 1, id == image.tiles[y - 2]![0]!.id { return false }
                if id == image.tiles[y - 1]![1]!.id { return false }
                if tile.matchingTiles.count > 3 { return false }
                return true
            }.first!.value
            image.tiles[y] = [0: tile]
        }
        for x in 1 ..< sideLength {
            let tile = image.tiles[y]![x - 1]!.matchingTiles.filter { id, tile in
                if y == 0, tile.matchingTiles.count > 3 { return false }
                if y > 0, id == image.tiles[y - 1]![x - 1]!.id { return false }
                if y > 0, !image.tiles[y - 1]![x]!.matchingTiles.contains(where: { $0.key == id }) { return false }
                if x > 1, id == image.tiles[y]![x - 2]!.id { return false }
                return true
            }.first!.value
            image.tiles[y]![x] = tile
        }
    }

    // image.updateData()
    // print(image)
    // print()

    for mutation in image.tiles[0]![0]!.getMutations(withRotation: true) {
        if
            image.tiles[0]![1]!.matches(border: mutation.getRightBorder(), borderFunction: Tile.getLeftBorder) != nil,
            image.tiles[1]![0]!.matches(border: mutation.getBottomBorder(), borderFunction: Tile.getTopBorder) != nil
        {
            image.tiles[0]![0] = mutation
            // print("tile found")
            break
        }
    }

    // image.updateData()
    // print(image)
    // print()

    for y in 0 ..< sideLength {
        if y > 0 {
            image.tiles[y]![0] = image.tiles[y]![0]!.matches(border: image.tiles[y - 1]![0]!.getBottomBorder(), borderFunction: Tile.getTopBorder)
        }
        for x in 1 ..< sideLength {
            image.tiles[y]![x] = image.tiles[y]![x]!.matches(border: image.tiles[y]![x - 1]!.getRightBorder(), borderFunction: Tile.getLeftBorder)
        }
    }

    image.updateData()
    // print(image)
    // print()

    var monsterCount = 0
    for mutatedImage in image.getMutations() {
        // print(image)
        monsterCount = mutatedImage.findSeeMonsters().count
        if monsterCount > 0 {
            image = mutatedImage
            break
        }
    }

    // print(image)

    return image.waterCount() - monsterCount * 15
}

print("Part 2: \(part2())")
