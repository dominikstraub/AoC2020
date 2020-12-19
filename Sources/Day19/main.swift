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

class RuleSet: CustomStringConvertible {
    var ruleIds: [Int] = []
    func getRules(allRules: [Int: Rule]) -> [Rule] {
        return ruleIds.compactMap { allRules[$0] }
    }

    init(line: String) {
        ruleIds = line.components(separatedBy: " ").compactMap { Int($0) }
    }

    public var description: String {
        ruleIds.map { "\($0)" }.joined(separator: " ")
    }
}

class Rule: CustomStringConvertible {
    var id: Int
    var character: String?
    var ruleSets: [RuleSet] = []
    var characterCounts: [String: [Int: Bool]] = [:]

    func match(message: String, allRules: [Int: Rule]) -> [Int] {
        print("testing: \(message) with \(self)")

        var path = 0
        if let characterCounts = characterCounts[message] {
            let characterCounts = characterCounts.compactMap { $0.value == false ? nil : $0.key }
            path = characterCounts.count
            // print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
            // return characterCounts
        } else {
            characterCounts[message] = [:]
        }

        if let character = character {
            let matches = message[0 ..< 1] == character
            characterCounts[message]![1] = matches
            print(matches ? "+" : "-")
            return matches ? [1] : []
        }

        for ruleSet in ruleSets {
            print("testing: \(message) with \(ruleSet)")
            var ruleSetMatches = false
            var ruleSetCharacterCounts: [Int: Bool] = [:]
            var index = 0
            for rule in ruleSet.getRules(allRules: allRules) {
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

                if path >= characterCounts.count {
                    let characterCounts = self.characterCounts[message]!.compactMap { $0.value == false ? nil : $0.key }
                    print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
                    return characterCounts
                } else {
                    index += characterCounts[path] // TODO:
                }
            }
            characterCounts[message]![index] = ruleSetMatches
        }

        let characterCounts = self.characterCounts[message]!.compactMap { $0.value == false ? nil : $0.key }
        print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
        return characterCounts
    }

    init(line: String) {
        let ruleParts = line.components(separatedBy: ": ")
        id = Int(ruleParts[0])!
        if ruleParts[1][0] == "\"" {
            character = ruleParts[1].components(separatedBy: "\"")[1]
        } else {
            ruleSets = ruleParts[1].components(separatedBy: " | ").compactMap { RuleSet(line: $0) }
        }
    }

    public var description: String {
        var string = "\(id): "
        if let character = character {
            string += "\"\(character)\""
        }
        return string + ruleSets.map { $0.description }.joined(separator: " | ")
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
