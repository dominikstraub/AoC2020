import Foundation

public func getInput(bundle: Bundle, file: String = "input") throws -> String {
    let inputFile = bundle.url(forResource: file, withExtension: "txt")!
    let input = try String(contentsOf: inputFile, encoding: .utf8)
    return input
}
