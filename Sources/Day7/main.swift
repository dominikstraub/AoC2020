import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
let input = try Utils.getInput(bundle: Bundle.module)

let ruleLines = input
    .components(separatedBy: "\n")

var rules = [String: [String: Int]]()
for rule in ruleLines {
    if rule == "" {
        continue
    }
    let words = rule
        .components(separatedBy: CharacterSet(charactersIn: " ,."))
        .map { (word) -> String? in
            if word == "" {
                return nil
            }
            return word
        }
        .compactMap { $0 }

    let ruleIndex = "\(words[0])-\(words[1])"
    rules[ruleIndex] = [String: Int]()
    if words.count <= 7 {
        continue
    }
    var index = 4
    while index + 2 < words.count {
        rules[ruleIndex]!["\(words[index + 1])-\(words[index + 2])"] = Int(words[index])!
        index += 4
    }
}

var containGolden: Set = ["shiny-gold"]
func canContainGolden(color: String) -> Bool {
    if containGolden.contains(color) {
        return true
    }
    for containee in rules[color]! {
        if canContainGolden(color: containee.key) {
            containGolden.insert(containee.key)
            return true
        }
    }
    return false
}

func part1() -> Int {
    var count = 0
    for rule in rules {
        if rule.key == "shiny-gold" {
            continue
        }
        if canContainGolden(color: rule.key) {
            count += 1
        }
    }
    return count
}

print("Part 1: \(part1())")

func countOfbagsIn(color: String) -> Int {
    var count = 0

    for currentColor in rules[color]! {
        count += currentColor.value * countOfbagsIn(color: currentColor.key)
        count += currentColor.value
    }

    return count
}

func part2() -> Int {
    return countOfbagsIn(color: "shiny-gold")
}

print("Part 2: \(part2())")
