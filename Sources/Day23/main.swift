import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let cups = input
    .components(separatedBy: "\n")[0]
    .compactMap { Int(String($0)) }

// print(cups)

struct CrabCups {
    var cups: LinkedList<Int> = []
    var currentCup: Int
    var pickedUp: LinkedList<Int> = []

    var currentCupIndex: LinkedListIndex<Int> {
        cups.firstIndex(of: currentCup)!
    }

    var destinationCup: Int {
        var destinationCup = currentCup
        while true {
            destinationCup = (destinationCup - 1) %% (cups.max()! + 1)
            if cups.contains(destinationCup) {
                return destinationCup
            }
        }
    }

    var destinationCupIndex: LinkedListIndex<Int> {
        cups.firstIndex(of: destinationCup)!
    }

    var nextCup: Int {
        cups[nextCupIndex]
    }

    var nextCupIndex: Int {
        (currentCupIndex.tag + 1) % cups.count
    }

    var order: String {
        cups.split(separator: 1).reversed().map { $0.map { "\($0)" }.joined() }.joined()
    }

    mutating func placeCups() {
        cups.insert(pickedUp, at: destinationCupIndex.tag + 1)
        pickedUp.removeAll()
    }

    mutating func pickUp() {
        pickedUp.append(cups.remove(at: nextCupIndex))
    }

    mutating func pickUp(times: Int) {
        for _ in 0 ..< times {
            pickUp()
        }
    }

    mutating func move() {
        // print(cups.prettyPrint)
        print("cups: \(cups)")
        pickUp(times: 3)
        print("pick up: \(pickedUp)")
        print("destination: \(destinationCup)")
        placeCups()
        currentCup = nextCup
    }

    mutating func move(moves: Int) {
        for moveNr in 0 ..< moves {
            print("\n-- move \(moveNr + 1) --")
            move()
        }
    }

    init(cups: [Int], fillUpTo max: Int = -1) {
        var cups = cups
        if max > 0 {
            cups.append(contentsOf: cups.max()! ... max)
        }
        for entry in cups {
            self.cups.append(entry)
        }
        currentCup = self.cups.first!
    }
}

func part1() -> String {
    var game = CrabCups(cups: cups)
    game.move(moves: 100)
    // print(game.cups.prettyPrint)
    print(game.cups)
    return game.order
}

print("Part 1: \(part1())")

func part2() -> Int {
    var game = CrabCups(cups: cups, fillUpTo: 1_000_000)
    game.move(moves: 10_000_000)
    let oneIndex = game.cups.firstIndex(of: 1)!
    return game.cups[oneIndex.tag + 1] * game.cups[oneIndex.tag + 2]
}

print("Part 2: \(part2())")
