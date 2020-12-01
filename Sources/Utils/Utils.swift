import Foundation

public func getInput(day: Int, file: String = "input.txt") throws -> String {
    let aocDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let dayDir = aocDir.appendingPathComponent("Sources/Day\(day)")
    let inputFile = dayDir.appendingPathComponent(file)
    let input = try String(contentsOf: inputFile, encoding: .utf8)
    return input
}
