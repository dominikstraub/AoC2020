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

struct Deck: CustomStringConvertible {
    var cards: [Int]

    var hasCardsLeft: Bool {
        !cards.isEmpty
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

    public var description: String {
        cards.map { "\($0)" }.joined(separator: ", ")
    }
}

var gameCount = 0

struct SpaceCards {
    var deck1: Deck
    var deck2: Deck

    var previousRounds: Set<Double> = []

    let gameNr: Int
    var roundCount = 0

    var winnerScore: Int {
        max(deck1.score, deck2.score)
    }

    var hashCode: Double {
        (10 ^^ (deck2.cards.count * 2)) * deck1.hashCode + deck2.hashCode
    }

    mutating func playRound() throws {
        roundCount += 1
        // print("\n-- Round \(roundCount) (Game \(gameNr)) --")
        // print("Player 1's deck: \(deck1)")
        // print("Player 2's deck: \(deck2)")
        let card1 = deck1.getNextCard()!
        let card2 = deck2.getNextCard()!
        // print("Player 1 plays: \(card1)")
        // print("Player 2 plays: \(card2)")
        if previousRounds.contains(hashCode) {
            // print("Player 1 wins round \(roundCount) of game \(gameNr)!")
            deck1.addRound(winningCard: card1, loosingCard: card2)
            throw Utils.DefaultError.message("Round already played, Player 1 wins")
        } else {
            previousRounds.insert(hashCode)
            if deck1.cards.count >= card1, deck2.cards.count >= card2 {
                // print("Playing a sub-game to determine the winner...\n")
                var innerGame = SpaceCards(cards: [Array(deck1.cards[..<card1]), Array(deck2.cards[..<card2])])
                innerGame.play()
                // print("\n...anyway, back to game \(gameNr).")
                if innerGame.deck1.hasCardsLeft {
                    deck1.addRound(winningCard: card1, loosingCard: card2)
                    // print("Player 1 wins round \(roundCount) of game \(gameNr)!")
                } else {
                    deck2.addRound(winningCard: card2, loosingCard: card1)
                    // print("Player 2 wins round \(roundCount) of game \(gameNr)!")
                }
            } else {
                // print("Player \(card1 > card2 ? 1 : 2) wins round \(roundCount) of game \(gameNr)!")
                deck1.evalRound(ownCard: card1, otherCard: card2)
                deck2.evalRound(ownCard: card2, otherCard: card1)
            }
        }
    }

    mutating func play() {
        while deck1.hasCardsLeft, deck2.hasCardsLeft {
            if (try? playRound()) == nil {
                break
            }
        }
        // print("The winner of game \(gameNr) is player \(deck1.hasCardsLeft ? 1 : 2)!")
    }

    init(decks: [Deck]) {
        gameCount += 1
        gameNr = gameCount
        // print("=== Game \(gameNr) ===")
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

    // print("\n\n== Post-game results ==")
    // print("Player 1's deck: \(game.deck1)")
    // print("Player 2's deck: \(game.deck2)")

    return game.winnerScore
}

print("Part 2: \(part2())")
