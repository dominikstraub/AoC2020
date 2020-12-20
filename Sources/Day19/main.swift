import Foundation
import Utils

let verbosity = 0

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
let input = try Utils.getInput(bundle: Bundle.module)

let parts = input
    .components(separatedBy: "\n\n")
    .compactMap { part -> [String] in
        part.components(separatedBy: "\n")
            .compactMap { line -> String? in
                if line == "" || line[0] == "#" {
                    return nil
                }
                return line
            }
    }

var rules: [Int: Rule] = [:]
for line in parts[0] {
    let rule = Rule.parse(line: line)
    rules[rule.id] = rule
    if verbosity > 1 {
        print(rule)
    }
}

protocol matchable {
    func match(message _: String, allRules _: [Int: Rule]) -> [Int]
}

class RuleSet: CustomStringConvertible, matchable {
    var ruleIds: [Int] = []

    func getRules(allRules: [Int: Rule]) -> [Rule] {
        return ruleIds.compactMap { allRules[$0] }
    }

    func match(message: String, allRules: [Int: Rule]) -> [Int] {
        if verbosity > 1 {
            print("testing: \(message) with \(self)")
        }

        var indices = [0]
        for rule in getRules(allRules: allRules) {
            if verbosity > 1 {
                print("sub...")
            }
            indices = indices.filter { message.count > $0 }
            let oldIndices = indices
            indices = []

            for index in oldIndices {
                if verbosity > 1 {
                    print("index...")
                }
                let message = String(message[index...])
                let characterCounts = rule.match(message: message, allRules: allRules)
                characterCounts.forEach {
                    indices.append(index + $0)
                }
            }
        }

        if verbosity > 1 {
            print(!indices.isEmpty ? "+ \(indices)" : "-")
        }
        return indices
    }

    init(setString: String) {
        ruleIds = setString.components(separatedBy: " ").compactMap { Int($0) }
    }

    public var description: String {
        ruleIds.map { "\($0)" }.joined(separator: " ")
    }
}

class Rule: CustomStringConvertible, matchable {
    static func parse(line: String) -> Rule {
        let ruleParts = line.components(separatedBy: ": ")
        if ruleParts[1][0] == "\"" {
            return ElementaryRule(ruleParts: ruleParts)
        } else {
            return Complex(ruleParts: ruleParts)
        }
    }

    let id: Int
    var characterCounts: [String: [Int: Bool]] = [:]

    func reset() {
        characterCounts = [:]
    }

    func match(message _: String, allRules _: [Int: Rule]) -> [Int] {
        if verbosity > 1 {
            print("========= ERROR ============")
        }
        exit(-1)
    }

    init(ruleParts: [String]) {
        id = Int(ruleParts[0])!
    }

    public var description: String {
        return "\(id): "
    }
}

extension Dictionary where Value == Rule {
    func resetAll() {
        forEach { $0.value.reset() }
    }
}

class Complex: Rule {
    let ruleSets: [RuleSet]

    override func match(message: String, allRules: [Int: Rule]) -> [Int] {
        if verbosity > 1 {
            print("testing: \(message) with \(self)")
        }

        if let characterCounts = characterCounts[message] {
            let characterCounts = characterCounts.compactMap { $0.value == false ? nil : $0.key }
            if verbosity > 1 {
                print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
            }
            return characterCounts
        } else {
            characterCounts[message] = [:]
        }

        for ruleSet in ruleSets {
            let ruleSetMatches = ruleSet.match(message: message, allRules: allRules)
            ruleSetMatches.forEach { characterCounts[message]![$0] = true }
        }

        if let characterCounts = self.characterCounts[message]?.compactMap({ $0.value == false ? nil : $0.key }) {
            if verbosity > 1 {
                print(!characterCounts.isEmpty ? "+ \(characterCounts)" : "-")
            }
            return characterCounts
        } else {
            return []
        }
    }

    override init(ruleParts: [String]) {
        ruleSets = ruleParts[1].components(separatedBy: " | ").compactMap { RuleSet(setString: $0) }
        super.init(ruleParts: ruleParts)
    }

    override public var description: String {
        return super.description + ruleSets.map { $0.description }.joined(separator: " | ")
    }
}

class ElementaryRule: Rule {
    let character: String

    override func match(message: String, allRules _: [Int: Rule]) -> [Int] {
        if verbosity > 1 {
            print("testing: \(message) with \(self)")
        }
        characterCounts[message] = [:]
        let matches = message[0 ..< 1] == character
        characterCounts[message]![1] = matches
        if verbosity > 1 {
            print(matches ? "+" : "-")
        }
        return matches ? [1] : []
    }

    override init(ruleParts: [String]) {
        character = ruleParts[1].components(separatedBy: "\"")[1]
        super.init(ruleParts: ruleParts)
    }

    override public var description: String {
        return super.description + "\"\(character)\""
    }
}

func validateMessages() -> [String] {
    return parts[1].compactMap { message in
        if verbosity > 0 {
            print("new message=======: \(message)")
        }
        if !rules[0]!.match(message: message, allRules: rules).compactMap({ $0 == message.count ? $0 : nil }).isEmpty {
            if verbosity > 0 {
                print("matched: \(message)")
            }
            return message
        } else {
            return nil
        }
    }
}

func part1() -> Int {
    return validateMessages().count
}

print("Part 1: \(part1())")

func part2() -> Int {
    rules[8] = Rule.parse(line: "8: 42 | 42 8")
    rules[11] = Rule.parse(line: "11: 42 31 | 42 11 31")
    rules.resetAll()
    return validateMessages().count
}

print("Part 2: \(part2())")
