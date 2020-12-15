import Foundation
import Utils

struct Instruction {
    var isMask = false
    var mask = ""
    var positiveMask: Int {
        var number = 0
        for index in 0 ..< mask.count {
            let startIndex = mask.index(mask.startIndex, offsetBy: mask.count - 1 - index)
            let endIndex = mask.index(mask.startIndex, offsetBy: mask.count - 1 - index + 1)
            if String(mask[startIndex ..< endIndex]) == "1" {
                number += 2 ^^ index
            }
        }
        return number
    }

    var negativeMask: Int {
        var number = 0
        for index in 0 ..< mask.count {
            let startIndex = mask.index(mask.startIndex, offsetBy: mask.count - 1 - index)
            let endIndex = mask.index(mask.startIndex, offsetBy: mask.count - 1 - index + 1)
            if String(mask[startIndex ..< endIndex]) == "0" {
                number += 2 ^^ index
            }
        }
        return ~number
    }

    var floatingMask: [Int] {
        var numbers: [Int] = []
        for index in 0 ..< mask.count {
            let startIndex = mask.index(mask.startIndex, offsetBy: mask.count - 1 - index)
            let endIndex = mask.index(mask.startIndex, offsetBy: mask.count - 1 - index + 1)
            if String(mask[startIndex ..< endIndex]) == "X" {
                numbers.append(index)
            }
        }
        return numbers
    }

    func getMaskedNumber(mask: Instruction?) -> Int {
        guard let mask = mask else { return number }
        return number | mask.positiveMask & mask.negativeMask
    }

    func getMaskedAddresses(mask: Instruction?) -> [Int] {
        guard let mask = mask else { return [address] }
        var addresses = [address | mask.positiveMask]
        for bit in mask.floatingMask {
            for i in 0 ..< addresses.count {
                addresses[i] = addresses[i] & ~(2 ^^ bit)
                addresses.append(addresses[i] | (2 ^^ bit))
            }
        }
        return addresses
    }

    var isMem: Bool {
        return !isMask
    }

    var address = -1
    var number = -1

    init(line: String) {
        let parts = line.components(separatedBy: " = ")
        if parts[0] == "mask" {
            isMask = true
            mask = parts[1]
        } else {
            isMask = false
            let memParts = parts[0].components(separatedBy: CharacterSet(charactersIn: "[]"))
            address = Int(memParts[1])!
            number = Int(parts[1])!
        }
    }
}

// let input = try Utils.getInput(bundle: Bundle.module, file: "test2")
// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let instructions = input
    .components(separatedBy: "\n")
    .map { line -> Instruction? in
        if line == "" {
            return nil
        }
        return Instruction(line: line)
    }
    .compactMap { $0 }

func part1() -> Int {
    var currentMask: Instruction?
    var mem: [Int] = []
    for instruction in instructions {
        if instruction.isMask {
            currentMask = instruction
        } else {
            let number = instruction.getMaskedNumber(mask: currentMask)
            while mem.count <= instruction.address {
                mem.append(0)
            }
            mem[instruction.address] = number
        }
    }
    return mem.reduce(0, +)
}

print("Part 1: \(part1())")

func part2() -> Int {
    var currentMask: Instruction?
    var mem: [Int: Int] = [:]
    for instruction in instructions {
        if instruction.isMask {
            currentMask = instruction
        } else {
            let addresses = instruction.getMaskedAddresses(mask: currentMask)
            for address in addresses {
                mem[address] = instruction.number
            }
        }
    }
    return mem.reduce(0) { (sum, entry) -> Int in
        sum + entry.value
    }
}

print("Part 2: \(part2())")
