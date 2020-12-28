import Foundation

public func getInput(bundle: Bundle, file: String = "input") throws -> String {
    let inputFile = bundle.url(forResource: file, withExtension: "txt")!
    let input = try String(contentsOf: inputFile, encoding: .utf8)
    return input
}

public extension StringProtocol {
    subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>) -> SubSequence { prefix(range.lowerBound + range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>) -> SubSequence { prefix(range.lowerBound + range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence { suffix(Swift.max(0, count - range.lowerBound)) }
}

public extension LosslessStringConvertible {
    var string: String { .init(self) }
}

public extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}

// modulo in swift can return negative numbers, so we make our own modulo operator
infix operator %%
public extension Int {
    static func %% (_ lhs: Int, _ rhs: Int) -> Int {
        if lhs >= 0 { return lhs % rhs }
        if lhs >= -rhs { return (lhs + rhs) }
        return ((lhs % rhs) + rhs) % rhs
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^: PowerPrecedence
public func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

public func ^^ (radix: Int, power: Int) -> Double {
    return pow(Double(radix), Double(power))
}

public enum DefaultError: Error {
    case message(String)
}
