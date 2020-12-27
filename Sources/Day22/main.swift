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

    var hashCode: Double {
        cards.reversed().enumerated().map {
            let value: Double = 10 ^^ ($0.offset * 2)
            return value * Double($0.element)
        }.reduce(0, +)
    }

    mutating func getNextCard() -> Int? {
        cards.removeFirst()
    }

    mutating func evalRound(ownCard: Int, otherCard: Int) {
        if ownCard > otherCard {
            addRound(winningCard: max(ownCard, otherCard), loosingCard: min(ownCard, otherCard))
        }
    }

    mutating func addRound(winningCard: Int, loosingCard: Int) {
        cards.append(winningCard)
        cards.append(loosingCard)
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

    var hashCode: Double {
        (10 ^^ (deck2.cards.count * 2)) * deck1.hashCode + deck2.hashCode
    }

    var previousRounds: Set<Double> = []

    mutating func playRound() {
        // print("\n-- new Round --")
        // print(deck1)
        // print(deck2)
        let card1 = deck1.getNextCard()!
        let card2 = deck2.getNextCard()!
        // print(card1)
        // print(card2)
        if previousRounds.contains(hashCode) {
            deck1.addRound(winningCard: card1, loosingCard: card2)
        } else {
            previousRounds.insert(hashCode)
            if deck1.cards.count >= card1, deck2.cards.count >= card2 {
                var innerGame = SpaceCards(cards: [Array(deck1.cards[..<card1]), Array(deck2.cards[..<card2])])
                innerGame.play()
                // print("...anyway, back to game")
                if innerGame.deck1.cards.isEmpty {
                    deck2.addRound(winningCard: card2, loosingCard: card1)
                } else {
                    deck1.addRound(winningCard: card1, loosingCard: card2)
                }
            } else {
                deck1.evalRound(ownCard: card1, otherCard: card2)
                deck2.evalRound(ownCard: card2, otherCard: card1)
            }
        }
    }

    mutating func play() {
        while deck1.hasCardsLeft, deck2.hasCardsLeft {
            playRound()
        }
    }

    init(decks: [Deck]) {
        // print("=== new Game ===")
        deck1 = decks[0]
        deck2 = decks[1]
    }

    init(cards: [[Int]]) {
        self.init(decks: [Deck(cards: cards[0]), Deck(cards: cards[1])])
    }
}

// func part1() -> Int {
//    var game = SpaceCards(decks: decks)
//    game.play()
//    return game.winnerScore
// }
//
// print("Part 1: \(part1())")

func part2() -> Int {
    var game = SpaceCards(decks: decks)
    game.play()
    return game.winnerScore
}

print("Part 2: \(part2())")
