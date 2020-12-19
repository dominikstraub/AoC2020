import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let parts = input
    .components(separatedBy: "\n\n")
    .compactMap { part -> [String] in
        part.components(separatedBy: "\n")
            .compactMap { line -> String? in
                if line == "" {
                    return nil
                }
                return line
            }
    }

class Rule: CustomStringConvertible {
    var id: Int
    var character: String?
    var ruleSets: [[Int]] = []

    public var description: String {
        var string = "\(id): "
        if let character = character {
            string += "\"\(character)\""
        }
        return string + ruleSets.map { $0.map { "\($0)" }.joined(separator: " ") }.joined(separator: " | ")
    }

    func match(message: String, allRules: [Int: Rule]) -> (matches: Bool, characterCount: Int) {
        // print("testing: \(message)")
        if let character = character {
            // print("matched elementary rule")
            return (matches: message[0 ..< 1] == character, characterCount: 1)
        }
        for ruleSet in ruleSets {
            var matches = true
            var characterCount = 0
            for ruleId in ruleSet {
                let rule = allRules[ruleId]!
                let message = String(message[characterCount...])
                // print("sub rule following...")
                let result = rule.match(message: message, allRules: allRules)
                if !result.matches {
                    matches = false
                    break
                }
                characterCount += result.characterCount
            }
            if matches {
                // print("matched complex rule (characterCount: \(characterCount))")
                return (matches: true, characterCount: characterCount)
            }
        }
        // print("no match")
        return (matches: false, characterCount: 0)
    }

    init(line: String) {
        let ruleParts = line.components(separatedBy: ": ")
        id = Int(ruleParts[0])!
        if ruleParts[1][0] == "\"" {
            character = ruleParts[1].components(separatedBy: "\"")[1]
        } else {
            ruleSets = ruleParts[1].components(separatedBy: " | ").compactMap { ruleSet in
                ruleSet.components(separatedBy: " ").compactMap { rule in
                    Int(rule)
                }
            }
        }
    }
}

func part1() -> Int {
    var rules: [Int: Rule] = [:]
    for line in parts[0] {
        let rule = Rule(line: line)
        rules[rule.id] = rule
        // print(rule)
    }
    var count = 0
    for message in parts[1] {
        // print("new message=======")
        let result = rules[0]!.match(message: message, allRules: rules)
        if result.matches, result.characterCount == message.count {
            count += 1
        }
    }
    return count
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
