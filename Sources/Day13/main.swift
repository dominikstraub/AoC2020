import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let lines = input
    .components(separatedBy: "\n")
    .map { line -> String? in
        if line == "" {
            return nil
        }
        return line
    }
    .compactMap { $0 }

let earliestTime = Int(lines[0])!
let allBusLines = lines[1].components(separatedBy: ",")
    .map { line -> Int? in
        if line == "" {
            return nil
        }
        if line == "x" {
            return nil
        }
        return Int(line)
    }

let busLines = allBusLines.compactMap { $0 }

func part1() -> Int {
    var earliestBus = (id: -1, time: -1)
    for busLine in busLines {
        var index = 0
        while true {
            let busTime = busLine * index
            index += 1
            if busTime < earliestTime {
                continue
            }
            if earliestBus.time == -1 || earliestBus.time > busTime {
                earliestBus.id = busLine
                earliestBus.time = busTime
            }
            break
        }
    }
    return earliestBus.id * (earliestBus.time - earliestTime)
}

print("Part 1: \(part1())")

// modulo in swift can return negative numbers, so we make our own modulo operator
infix operator %%
extension Int {
    static func %% (_ lhs: Int, _ rhs: Int) -> Int {
        if lhs >= 0 { return lhs % rhs }
        if lhs >= -rhs { return (lhs + rhs) }
        return ((lhs % rhs) + rhs) % rhs
    }
}

// extended Euclidean algorithm
func euclid(_ m: Int, _ n: Int) -> (Int, Int) {
    if m % n == 0 {
        return (0, 1)
    } else {
        let (r, s) = euclid(n %% m, m)
        return (s - r * (n / m), r)
    }
}

// Chinese Remainder Theorem
func crt(_ aa: [Int], _ ii: [Int]) -> Int {
    let n = ii.reduce(1, *)
    let x = aa.enumerated().reduce(0) { (sum, tmp) -> Int in
        let (i, a) = tmp
        return sum + a * euclid(ii[i], n / ii[i]).1 * (n / ii[i])
    }
    return x %% n
}

func part2() -> Int {
    var diff: [Int] = []
    for index in 0 ..< allBusLines.count {
        if allBusLines[index] == nil {
            continue
        }
        diff.append(allBusLines.count - index - 1)
    }
    return crt(diff, busLines) - diff[0]
}

print("Part 2: \(part2())")
