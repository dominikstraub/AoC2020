import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let cups = input
    .components(separatedBy: "\n")[0]
    .compactMap { Int(String($0)) }

struct CrabCups {
    var cups: LinkedList<Int> = []
    var currentCup: LinkedList<Int>.Node
    var pickedUp: LinkedList<Int> = []

    var cupsMap: [Int: LinkedList<Int>.Node] = [:]
    let max: Int

    var destinationCup: LinkedList<Int>.Node {
        var destinationValue = currentCup.value
        while true {
            destinationValue = (destinationValue - 1) %% (max + 1)
            if destinationValue != 0, !pickedUp.contains(destinationValue) {
                return cupsMap[destinationValue]!
            }
        }
    }

    var nextCup: LinkedList<Int>.Node {
        if let next = currentCup.next {
            return next
        } else {
            return cups.head!
        }
    }

    var order: String {
        var result = ""
        var currentNode = cupsMap[1]!.next
        while let node = currentNode, node.value != 1 {
            result += "\(node.value)"
            currentNode = node.next ?? cups.head
        }
        return result
    }

    mutating func placeCups() {
        cups.insert(pickedUp, after: destinationCup)
        pickedUp.removeAll()
    }

    mutating func pickUp() {
        pickedUp.append(cups.remove(node: nextCup))
    }

    mutating func pickUp(times: Int) {
        for _ in 0 ..< times {
            pickUp()
        }
    }

    mutating func move() {
        // print(cups.prettyPrint)
        // print("cups: \(cups)")
        // print(cups.count)
        pickUp(times: 3)
        // print(pickedUp.prettyPrint)
        // print("pick up: \(pickedUp)")
        // print(pickedUp.count)
        // print("destination: \(destinationCup)")
        placeCups()
        currentCup = nextCup
    }

    mutating func move(moves: Int) {
        for moveNr in 1 ... moves {
            if moveNr % 100_000 == 0 {
                print("\n-- move \(moveNr) --")
            }
            move()
        }
    }

    init(cups: [Int], fillUpTo max: Int = -1) {
        var cups = cups
        if max > 0 {
            cups.append(contentsOf: cups.max()! + 1 ... max)
        }
        for entry in cups {
            cupsMap[entry] = self.cups.append(entry)
        }
        self.max = self.cups.max()!
        currentCup = self.cups.head!
    }
}

func part1() -> String {
    var game = CrabCups(cups: cups)
    game.move(moves: 100)
    // print(game.cups.prettyPrint)
    // print(game.cups)
    return game.order
}

print("Part 1: \(part1())")

func part2() -> Double {
    var game = CrabCups(cups: cups, fillUpTo: 1_000_000)
    game.move(moves: 10_000_000)
    let oneCup = game.cupsMap[1]!
    let nextCup = oneCup.next!
    let nextNextCup = nextCup.next!
    print(nextCup.value)
    print(nextNextCup.value)
    let result = Double(nextCup.value) * Double(nextNextCup.value)
    print(result)
    return result
}

print("Part 2: \(part2())")
