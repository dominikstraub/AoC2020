import Foundation
import Utils

let verbosity = 1

// let input = try Utils.getInput(bundle: Bundle.module, file: "input")
let input = try Utils.getInput(bundle: Bundle.module, file: "test")

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .compactMap { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }

class Expression {
    var inputString = ""
    var partsCount = 0
    var op: String?
    var result: Int?
    var expression1: Expression?
    var number2: Int?
    var expression2: Expression?

    var term2: Int? {
        if let number2 = number2 {
            return number2
        } else if let expression2 = expression2 {
            return expression2.evaluate()
        } else {
            return nil
        }
    }

    func evaluate() -> Int? {
        if let result = result {
            return result
        }
        guard let term2 = term2 else {
            return nil
        }
        guard let term1 = expression1?.evaluate(), let op = op else {
            result = term2
            if verbosity > 1 {
                print(result!)
            }
            return result
        }
        switch op {
        case "+":
            result = term1 + term2
            if verbosity > 1 {
                print("\(term1) + \(term2) = \(result!)")
            }
            return result
        case "*":
            result = term1 * term2
            if verbosity > 1 {
                print("\(term1) * \(term2) = \(result!)")
            }
            return result
        default:
            return nil
        }
    }

    func toString() -> String {
        return "\(inputString) = \(evaluate() ?? -1)"
    }

    init(_ string: String, oneTermOnly: Bool = false) {
        if verbosity > 1 {
            print(string)
        }
        inputString = string
        var parts: [String] = string.components(separatedBy: " ").compactMap { $0 == "" ? nil : $0 }
        partsCount = parts.count
        guard let lastChar = string.last else { return }
        if lastChar == ")" {
            var parCount = 1
            var index = string.count - 2
            while index >= 0 {
                if string[index] == ")" {
                    parCount += 1
                }
                if string[index] == "(" {
                    parCount -= 1
                }
                if parCount == 0 {
                    break
                }
                index -= 1
            }
            let parPart = String(string[string.index(string.startIndex, offsetBy: index + 1) ... string.index(string.endIndex, offsetBy: -2)])
            expression2 = Expression(parPart)
            if index >= 2 {
                let rest = String(string[...string.index(string.startIndex, offsetBy: index - 2)])
                parts = rest.components(separatedBy: " ")
            }
        } else {
            parts = string.components(separatedBy: " ")
            number2 = Int(parts.removeLast())
            if verbosity > 1 {
                print(number2 ?? "")
            }
        }
        if !parts.isEmpty {
            op = parts.removeLast()
            if op == "+" {
                let newExpression2 = Expression()
                newExpression2.inputString = inputString
                if let expression2 = expression2 {
                    newExpression2.expression2 = expression2
                    newExpression2.partsCount += expression2.partsCount
                    self.expression2 = nil
                }
                if let number2 = number2 {
                    newExpression2.number2 = number2
                    newExpression2.partsCount += 1
                    self.number2 = nil
                }
                if let op = op {
                    newExpression2.op = op
                    newExpression2.partsCount += 1
                    self.op = nil
                }
                newExpression2.expression1 = Expression(parts.joined(separator: " "), oneTermOnly: true)
                newExpression2.partsCount += newExpression2.expression1!.partsCount
                parts.removeLast(newExpression2.expression1!.partsCount)
                if !oneTermOnly, !parts.isEmpty {
                    op = parts.removeLast()
                }
                expression2 = newExpression2
            }
            if oneTermOnly {
                if let op = op {
                    parts.append(op)
                }
                op = nil
            } else {
                expression1 = Expression(parts.joined(separator: " "))
                parts.removeLast(expression1!.partsCount)
            }
        }
        partsCount -= parts.count
    }

    init() {}
}

func part2() -> Int {
    var sum = 0
    for line in lines {
        if line[0] == "#" {
            if verbosity > 0 {
                print("comment: \(line[1...])")
            }
            continue
        }
        let exp = Expression(line)
        sum += exp.evaluate()!
        if verbosity > 0 {
            print(exp.toString())
        }
        if verbosity > 1 {
            print("\n==========================\n")
        }
    }
    return sum
}

print("Part 2: \(part2())")
