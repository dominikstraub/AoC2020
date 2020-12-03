import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let field = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .map { (item) -> [Bool]? in
        if item == "" {
            return nil
        }
        return Array(item)
            .map { $0 == "#" }
    }
    .compactMap { $0 }

func part1(field: [[Bool]], slope: Double = 3) -> Int {
    var trees = 0
    for i in 0..<field.count {
        let s = Double(i) * slope
        if s.truncatingRemainder(dividingBy: 1) != 0 {
            continue
        }
        let line = field[i]
        if line[Int(s) % line.count] == true {
            trees += 1
        }
    }
    return trees
}

print("Part 1: \(part1(field: field))")

func part2(field: [[Bool]]) -> Int {
    let slopes = [1, 3, 5, 7, 0.5]
    var result = 1
    for slope in slopes {
        result *= part1(field: field, slope: slope)
    }
    return result
}

print("Part 2: \(part2(field: field))")
