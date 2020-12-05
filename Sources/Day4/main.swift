import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let passports = input
    .components(separatedBy: "\n\n")
    .map { (passport) -> [String: String]? in
        if passport == "" {
            return nil
        }
        return passport
            .components(separatedBy: CharacterSet(charactersIn: "\n "))
            .map { (field) -> String? in
                if field == "" {
                    return nil
                }
                return field
            }
            .compactMap { $0 }
            .reduce([String: String]()) { (passport, field) -> [String: String] in
                let parts = field
                    .components(separatedBy: ":")
                var psprt = passport
                psprt[parts[0]] = parts[1]
                return psprt
            }
    }
    .compactMap { $0 }

func part1(passports: [[String: String]]) -> Int {
    let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    var validCount = 0
    for passport in passports {
        var valid = true
        for field in requiredFields where passport[field] == nil {
            valid = false
            break
        }
        if valid {
            validCount += 1
        }
    }
    return validCount
}

print("Part 1: \(part1(passports: passports))")

func part2(passports: [[String: String]]) -> Int {
    let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    var validCount = 0
    guard let hclRegex = try? NSRegularExpression(pattern: "^#[0-9a-f]{6}$") else { return -1 }
    for passport in passports {
        var valid = true
        for field in requiredFields where passport[field] == nil {
            valid = false
            break
        }
        if let byr = Int(passport["byr"] ?? "-1") {
            if byr < 1920 || byr > 2002 {
                valid = false
            }
        } else {
            valid = false
        }

        if let iyr = Int(passport["iyr"] ?? "-1") {
            if iyr < 2010 || iyr > 2020 {
                valid = false
            }
        } else {
            valid = false
        }

        if let eyr = Int(passport["eyr"] ?? "-1") {
            if eyr < 2020 || eyr > 2030 {
                valid = false
            }
        } else {
            valid = false
        }

        if let hgt = passport["hgt"] {
            let split = hgt.index(hgt.endIndex, offsetBy: -2)
            let unit = hgt[split ..< hgt.endIndex]
            guard let value = Int(hgt[hgt.startIndex ..< split]) else { valid = false; continue }
            if unit == "cm" {
                if value < 150 || value > 193 {
                    valid = false
                }
            } else if unit == "in" {
                if value < 59 || value > 76 {
                    valid = false
                }
            }
        } else {
            valid = false
        }

        guard let hcl = passport["hcl"] else { valid = false; continue }
        let hclRange = NSRange(location: 0, length: hcl.count)
        if hclRegex.numberOfMatches(in: hcl, options: [], range: hclRange) < 1 { valid = false; continue }

        guard let ecl = passport["ecl"] else { valid = false; continue }
        let validEcl = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        if !validEcl.contains(ecl) { valid = false; continue }

        guard let pid = passport["pid"] else { valid = false; continue }
        if pid.count != 9 { valid = false; continue }
        if Int(pid) == nil { valid = false; continue }

        if valid {
            validCount += 1
        }
    }
    return validCount
}

print("Part 2: \(part2(passports: passports))")
