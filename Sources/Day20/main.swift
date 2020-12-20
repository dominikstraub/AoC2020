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

print(tiles)

class Tile: CustomStringConvertible {
    let id: Int
    let data: [[Bool]]

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
        var newData: [[Bool]] = []
        for (y, line) in data.enumerated() {
            newData[y] = []
            for (x, _) in line.enumerated() {
                newData[y][x] = data[data.count - x][y]
            }
        }
        return Tile(tile: self, data: newData).rotated(times: times - 1)
    }

    init(lines: [String]) {
        id = Int(lines[0].components(separatedBy: CharacterSet(charactersIn: " :"))[1])!
        data = lines[1...].map { $0.map { $0 == "#" }}
    }

    init(tile: Tile, data: [[Bool]]) {
        id = tile.id
        self.data = data
    }

    public var description: String {
        "\(id)"
    }
}

func part1() -> Int {
    -1
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
