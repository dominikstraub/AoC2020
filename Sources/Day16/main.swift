import Foundation
import Utils

let input = try Utils.getInput(bundle: Bundle.module, file: "input")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")

let inputs = input.components(separatedBy: "\n\n")
    .map { part -> [String]? in
        if part == "" {
            return nil
        }
        return part.components(separatedBy: "\n")
            .compactMap { $0 }
    }
    .compactMap { $0 }

let rules = inputs[0]
    .map { line -> (field: String, ranges: [ClosedRange<Int>]) in
        let parts = line.components(separatedBy: ": ")
            .map { part -> String? in
                if part == "" {
                    return nil
                }
                return part
            }
            .compactMap { $0 }

        let rules = parts[1].components(separatedBy: " or ")
            .map { rule -> String? in
                if rule == "" {
                    return nil
                }
                return rule
            }
            .compactMap { $0 }

        let range1 = rules[0].components(separatedBy: CharacterSet(charactersIn: "-"))
        let range2 = rules[1].components(separatedBy: CharacterSet(charactersIn: "-"))
        return (field: parts[0], ranges: [Int(range1[0])! ... Int(range1[1])!, Int(range2[0])! ... Int(range2[1])!])
    }

let ticket = inputs[1][1]
    .components(separatedBy: ",")
    .map { Int($0)! }

let nearby = inputs[2]
    .map { line -> [Int]? in
        if line == "" || line == "nearby tickets:" {
            return nil
        }
        return line.components(separatedBy: ",")
            .map { Int($0)! }
    }
    .compactMap { $0 }

var validTickets: [[Int]] = []

func part1() -> Int {
    var errorRate = 0
    for ticket in nearby {
        var valid = true
        for field in ticket {
            var match = false
            for rule in rules {
                for range in rule.ranges {
                    if range.contains(field) {
                        match = true
                        break
                    }
                }
                if match {
                    break
                }
            }
            if match == false {
                errorRate += field
                valid = false
            }
        }
        if valid {
            validTickets.append(ticket)
        }
    }
    return errorRate
}

print("Part 1: \(part1())")

func part2() -> Int {
    var possibleFieldMap: [Int: [String: Bool]] = [:]
    for ticket in validTickets {
        for (index, field) in ticket.enumerated() {
            if possibleFieldMap[index] == nil {
                possibleFieldMap[index] = [:]
            }
            for rule in rules {
                if possibleFieldMap[index]![rule.field] == nil {
                    possibleFieldMap[index]![rule.field] = true
                } else if possibleFieldMap[index]![rule.field] == false {
                    continue
                }
                var match = false
                for range in rule.ranges {
                    if range.contains(field) {
                        match = true
                        break
                    }
                }
                if !match {
                    possibleFieldMap[index]![rule.field] = false
                }
            }
        }
    }
    var fieldMap: [String: Int] = [:]
    while possibleFieldMap.count > 0 {
        for (index, rules) in possibleFieldMap {
            if rules.count == 0 {
                possibleFieldMap.removeValue(forKey: index)
                continue
            }
            for (rule, match) in rules {
                if !match || fieldMap[rule] != nil {
                    possibleFieldMap[index]!.removeValue(forKey: rule)
                    continue
                }
                // fieldMap
            }
        }
        for (index, rules) in possibleFieldMap where rules.count == 1 {
            fieldMap[rules.first!.key] = index
        }
    }

    var result = 1
    for rule in rules {
        if rule.field.starts(with: "departure") {
            result *= ticket[fieldMap[rule.field]!]
        }
    }
    return result
}

print("Part 2: \(part2())")
