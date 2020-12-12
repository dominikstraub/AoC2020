import Foundation
import Utils

// let input = try Utils.getInput(bundle: Bundle.module, file: "test")
let input = try Utils.getInput(bundle: Bundle.module)

let instructions = input
    .components(separatedBy: "\n")
    .map { instruction -> (direction: String, value: Int)? in
        if instruction == "" {
            return nil
        }
        let split = instruction.index(instruction.startIndex, offsetBy: 1)
        let direction = String(instruction[instruction.startIndex ..< split])
        let value = Int(instruction[split ..< instruction.endIndex])!
        return (direction: direction, value: value)
    }
    .compactMap { $0 }

func moveShip(currentPosition: (south: Int, east: Int, heading: Int), instruction: (direction: String, value: Int)) -> (south: Int, east: Int, heading: Int) {
    var currentPosition = currentPosition
    switch instruction.direction {
    case "N":
        currentPosition.south -= instruction.value
    case "S":
        currentPosition.south += instruction.value
    case "E":
        currentPosition.east += instruction.value
    case "W":
        currentPosition.east -= instruction.value
    case "L":
        currentPosition.heading = (currentPosition.heading + (360 - instruction.value)) % 360
    case "R":
        currentPosition.heading = (currentPosition.heading + instruction.value) % 360
    case "F":
        switch currentPosition.heading {
        case 0:
            currentPosition = moveShip(currentPosition: currentPosition, instruction: ("N", instruction.value))
        case 90:
            currentPosition = moveShip(currentPosition: currentPosition, instruction: ("E", instruction.value))

        case 180:
            currentPosition = moveShip(currentPosition: currentPosition, instruction: ("S", instruction.value))

        case 270:
            currentPosition = moveShip(currentPosition: currentPosition, instruction: ("W", instruction.value))
        default:
            print("F direction \(currentPosition)")
        }
    default:
        print("direction unkown")
    }
    return currentPosition
}

func part1() -> Int {
    var currentPosition = (south: 0, east: 0, heading: 90)
    for instruction in instructions {
        currentPosition = moveShip(currentPosition: currentPosition, instruction: instruction)
    }
    return abs(currentPosition.south) + abs(currentPosition.east)
}

print("Part 1: \(part1())")

func moveWaypoint(position: (ship: (south: Int, east: Int), waypoint: (south: Int, east: Int)), instruction: (direction: String, value: Int)) -> ((south: Int, east: Int), (south: Int, east: Int)) {
    var position = position
    switch instruction.direction {
    case "N":
        position.waypoint.south -= instruction.value
    case "S":
        position.waypoint.south += instruction.value
    case "E":
        position.waypoint.east += instruction.value
    case "W":
        position.waypoint.east -= instruction.value
    case "L":
        for _ in 0 ..< instruction.value / 90 {
            position.waypoint = (south: -position.waypoint.east, east: position.waypoint.south)
        }
    case "R":
        for _ in 0 ..< instruction.value / 90 {
            position.waypoint = (south: position.waypoint.east, east: -position.waypoint.south)
        }
    case "F":
        position.ship.south += position.waypoint.south * instruction.value
        position.ship.east += position.waypoint.east * instruction.value
    default:
        print("direction unkown")
    }
    return position
}

func part2() -> Int {
    var position = (ship: (south: 0, east: 0), waypoint: (south: -1, east: 10))
    for instruction in instructions {
        position = moveWaypoint(position: position, instruction: instruction)
    }
    return abs(position.ship.south) + abs(position.ship.east)
}

print("Part 2: \(part2())")
