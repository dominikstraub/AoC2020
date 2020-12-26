import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let foods = input
    .components(separatedBy: "\n")
    .compactMap { line -> (Set<String>, Set<String>)? in
        if line == "" {
            return nil
        }
        let parts = line.components(separatedBy: " (contains ")
        let ingredients = Set(parts[0].components(separatedBy: " "))
        let allergens = Set(parts[1].components(separatedBy: CharacterSet(charactersIn: ", )")).compactMap { $0 == "" ? nil : $0 })
        return (ingredients, allergens)
    }

// print(foods)
var possibilities: [String: Set<String>] = [:]
for (ingredients, allergens) in foods {
    for allergen in allergens {
        if let entry = possibilities[allergen] {
            possibilities[allergen] = ingredients.intersection(entry)
        } else {
            possibilities[allergen] = ingredients
        }
    }
}

// print(possibilities)
var allergenMap: [String: String] = [:]
while possibilities.count > 0 {
    for (allergen, ingredients) in possibilities where ingredients.count == 1 {
        let ingredient = ingredients.first!
        allergenMap[allergen] = ingredient
        possibilities.removeValue(forKey: allergen)
        for (allergen, ingredients) in possibilities where ingredients.contains(ingredient) {
            var ingredients = ingredients
            ingredients.remove(ingredient)
            possibilities[allergen] = ingredients
        }
    }
}

// print(allergenMap)

func part1() -> Int {
    var count = 0
    for (ingredients, _) in foods {
        for ingredient in ingredients where !allergenMap.contains(where: { $0.value.contains(ingredient) }) {
            count += 1
        }
    }
    return count
}

print("Part 1: \(part1())")

func part2() -> String {
    return allergenMap.sorted { $0.key < $1.key }.map { $0.value }.joined(separator: ",")
}

print("Part 2: \(part2())")
