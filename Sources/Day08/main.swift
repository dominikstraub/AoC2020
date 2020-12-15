import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

var instructions = input
    .components(separatedBy: "\n")
    .map { instruction -> (op: String, arg: Int)? in
        if instruction == "" {
            return nil
        }
        let parts = instruction
            .components(separatedBy: " ")
        return (op: parts[0], arg: Int(parts[1])!)
    }
    .compactMap { $0 }

var accumulator = 0
func runAnalysis(instructions: [(op: String, arg: Int)]) -> Int {
    var indeces: Set<Int> = []
    var index = 0
    while true {
        if indeces.contains(index) {
            return -1
        }
        indeces.insert(index)
        if index >= instructions.count {
            return 0
        }
        let instruction = instructions[index]
        let op = instruction.op
        let arg = instruction.arg
        switch op {
        case "acc":
            accumulator += arg
        case "jmp":
            index += arg - 1
        default:
            break
        }
        index += 1
    }
}

func part1() -> Int {
    accumulator = 0
    _ = runAnalysis(instructions: instructions)
    return accumulator
}

print("Part 1: \(part1())")

func fixCode() {
    for index in 0 ..< instructions.count {
        let op = instructions[index].op
        if op == "nop" {
            instructions[index].op = "jmp"
        } else if op == "jmp" {
            instructions[index].op = "nop"
        }

        accumulator = 0
        if runAnalysis(instructions: instructions) == 0 {
            return
        }

        // change it back
        instructions[index].op = op
    }
}

func part2() -> Int {
    fixCode()
    return accumulator
}

print("Part 2: \(part2())")
