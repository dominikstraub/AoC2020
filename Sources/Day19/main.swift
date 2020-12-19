import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
// let input = try Utils.getInput(bundle: Bundle.module)

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
    var rules: [Rule] = []
    var ruleIds: [Int] = []
    var characterCounts: [String: [Int: Bool]] = [:]

    func getRules(allRules: [Int: Rule]) -> [Rule] {
        if ruleIds.isEmpty {
            return rules
        } else {
            return ruleIds.compactMap { allRules[$0] }
        }
    }

    func match(message: String, allRules: [Int: Rule]) -> [Int] {
        print("testing: \(message) with \(self)")

        if let characterCounts = characterCounts[message] {
            let characterCounts = characterCounts.compactMap { $0.value == false ? nil : $0.key }
            print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
            return characterCounts
        }
        characterCounts[message] = [:]

        if let character = character {
            let matches = message[0 ..< 1] == character
            characterCounts[message]![1] = matches
            print(matches ? "+" : "-")
            return matches ? [1] : []
        }

        for rule in getRules(allRules: allRules) {
            print("testing: \(message) with \(rule)")
            var ruleSetMatches = false
            var ruleSetCharacterCounts: [Int: Bool] = [:]
            var index = 0
            for rule in rule.getRules(allRules: allRules) {
                if message.count <= index {
                    print("\(ruleSetMatches)")
                    print("\(index)")
                    print("--")
                    break
                }
                let message = String(message[index...])
                print("sub...")
                let characterCounts = rule.match(message: message, allRules: allRules)
                if characterCounts.isEmpty {
                    break
                }
                ruleSetMatches = true

                characterCounts.forEach { ruleSetCharacterCounts[$0] = true }
                index += characterCounts[0] // TODO:
            }
            characterCounts[message]![index] = ruleSetMatches
        }

        let characterCounts = self.characterCounts[message]!.compactMap { $0.value == false ? nil : $0.key }
        print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
        return characterCounts
    }

    init(line: String) {
        let ruleParts = line.components(separatedBy: ": ")
        if ruleParts.count == 1 {
            id = -1
            ruleIds = line.components(separatedBy: " ").compactMap { Int($0) }
        } else {
            id = Int(ruleParts[0])!
            if ruleParts[1][0] == "\"" {
                character = ruleParts[1].components(separatedBy: "\"")[1]
            } else {
                rules = ruleParts[1].components(separatedBy: " | ").compactMap { Rule(line: $0) }
            }
        }
    }

    public var description: String {
        return "desc"
//        var string = "\(id): "
//        if let character = character {
//            string += "\"\(character)\""
//        }
//        return string + getRules.map { $0.map { "\($0.ruleIds)" }.joined(separator: " ") }.joined(separator: " | ")
    }
}

// func part1() -> Int {
//     var rules: [Int: Rule] = [:]
//     for line in parts[0] {
//         let rule = Rule(line: line)
//         rules[rule.id] = rule
//         // print(rule)
//     }
//     var count = 0
//     for message in parts[1] {
//         // print("new message=======")
//         let result = rules[0]!.match(message: message, allRules: rules)
//         if result.matches, result.characterCount == message.count {
//             print("matched: \(message)")
//             count += 1
//         }
//     }
//     return count
// }

// print("Part 1: \(part1())")

func part2() -> Int {
    var rules: [Int: Rule] = [:]
    for line in parts[0] {
        let rule = Rule(line: line)
        rules[rule.id] = rule
        // print(rule)
    }
    rules[8] = Rule(line: "8: 42 | 42 8")
    rules[11] = Rule(line: "11: 42 31 | 42 11 31")
    var count = 0
    for message in parts[1] {
        // print("new message=======")
        if !rules[0]!.match(message: message, allRules: rules).compactMap({ $0 == message.count ? $0 : nil }).isEmpty {
            print("matched: \(message)")
            count += 1
        }
    }
    return count
}

print("Part 2: \(part2())")
