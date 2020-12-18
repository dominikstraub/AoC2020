import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "input")
let input = try Utils.getInput(bundle: Bundle.module, file: "test")

let lines = input
    .components(separatedBy: CharacterSet(charactersIn: "\n"))
    .map { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }
    .compactMap { $0 }

class Expression {
    var expression1: Expression?
    var number1: Int?
    var term1: Int? {
        if let number1 = number1 {
            return number1
        } else if let expression1 = expression1 {
            return expression1.evaluate()
        } else {
            return nil
        }
    }

    var expression2: Expression?
    var number2: Int?
    var term2: Int? {
        if let number2 = number2 {
            return number2
        } else if let expression2 = expression2 {
            return expression2.evaluate()
        } else {
            return nil
        }
    }

    var op: String?
    func evaluate() -> Int? {
        guard let term2 = term2 else { return nil }
        guard let term1 = term1, let op = op else {
            return term2
        }
        switch op {
        case "+":
            return term1 + term2
        case "*":
            return term1 * term2
        default:
            return nil
        }
    }

    var inputString: String?
    func toString() -> String {
        return "\(inputString ?? "") = \(evaluate() ?? -1)"
    }

    init(string: String) {
        inputString = string
        let lastChar = string.last!
        var parts: [String] = []
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
            expression2 = Expression(string: parPart)
            if index > 0 {
                let rest = String(string[...string.index(string.startIndex, offsetBy: index - 2)])
                parts = rest.components(separatedBy: " ")
            }
        } else {
            parts = string.components(separatedBy: " ")
            number2 = Int(parts.removeLast())
        }
        if !parts.isEmpty {
            op = parts.removeLast()
            if !parts.isEmpty {
                if op == "+" {
                    //
                } else {
                    expression1 = Expression(string: parts.joined(separator: " "))
                }
            }
        }
    }
}

//               2 * 3 + 4 * 5
//               (2 * 3) + 4 * 5
//               2 * 3 + (4 * 5)
//               (2 * 3) + (4 * 5)

func part1() -> Int {
    var sum = 0
    for line in lines {
        let exp = Expression(string: line)
        sum += exp.evaluate()!
        print(exp.toString())
    }
    // print(Expression(string: lines[4]).toString())
    return sum
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
