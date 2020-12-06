import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let answers = input
    .components(separatedBy: "\n\n")
    .map { (groupAnswers) -> [String]? in
        if groupAnswers == "" {
            return nil
        }
        return groupAnswers
            .components(separatedBy: CharacterSet(charactersIn: "\n"))
            .map { (personAnswers) -> String? in
                if personAnswers == "" {
                    return nil
                }
                return personAnswers
            }
            .compactMap { $0 }
    }
    .compactMap { $0 }

func part1(answers _: [[String]]) -> Int {
    let count = answers.map { (groupAnswers) -> Int in
        var uniqueAnswers = [Character: Bool]()
        for personAnswers in groupAnswers {
            for answer in personAnswers {
                uniqueAnswers[answer] = true
            }
        }
        return uniqueAnswers.count
    }.reduce(0) { (sum, groupCount) -> Int in
        sum + groupCount
    }
    return count
}

print("Part 1: \(part1(answers: answers))")

func part2(answers _: [[String]]) -> Int {
    let count = answers.map { (groupAnswers) -> Int in
        var answerCount = [Character: Int]()
        for personAnswers in groupAnswers {
            for answer in personAnswers {
                answerCount[answer] = (answerCount[answer] ?? 0) + 1
            }
        }
        var allAnswers = [Character: Bool]()
        for (answer, count) in answerCount where count == groupAnswers.count {
            allAnswers[answer] = true
        }
        return allAnswers.count
    }.reduce(0) { (sum, groupCount) -> Int in
        sum + groupCount
    }
    return count
}

print("Part 2: \(part2(answers: answers))")
