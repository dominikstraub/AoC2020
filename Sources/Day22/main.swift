import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let decks = input
    .components(separatedBy: "\n\n")
    .compactMap { part -> Deck? in
        if part == "" {
            return nil
        }
        return Deck(cards: part.components(separatedBy: "\n")
            .compactMap { line -> Int? in
                if line[..<6] == "Player" {
                    return nil
                }
                return Int(line)
            })
    }

struct Deck {
    var cards: [Int]

    var hasCardsLeft: Bool {
        cards.count > 0
    }

    var score: Int {
        cards.reversed().enumerated().map { ($0.offset + 1) * $0.element }.reduce(0, +)
    }

    mutating func getNextCard() -> Int? {
        cards.removeFirst()
    }

    mutating func evalRound(ownCard: Int, otherCard: Int) {
        if ownCard > otherCard {
            addRound(card1: ownCard, card2: otherCard)
        }
    }

    mutating func addRound(card1: Int, card2: Int) {
        cards.append(max(card1, card2))
        cards.append(min(card1, card2))
    }

    init(cards: [Int]) {
        self.cards = cards
    }
}

struct SpaceCards {
    var deck1: Deck
    var deck2: Deck

    var winnerScore: Int {
        max(deck1.score, deck2.score)
    }

    mutating func playRound() {
        let card1 = deck1.getNextCard()!
        let card2 = deck2.getNextCard()!
        deck1.evalRound(ownCard: card1, otherCard: card2)
        deck2.evalRound(ownCard: card2, otherCard: card1)
    }

    mutating func play() {
        while deck1.hasCardsLeft, deck2.hasCardsLeft {
            playRound()
        }
    }

    init(decks: [Deck]) {
        deck1 = decks[0]
        deck2 = decks[1]
    }
}

func part1() -> Int {
    var game = SpaceCards(decks: decks)
    game.play()
    return game.winnerScore
}

print("Part 1: \(part1())")

// func part2() -> Int {
//     return -1
// }

// print("Part 2: \(part2())")
