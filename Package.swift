// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AoC2020",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Utils",
            dependencies: []
        ),
        .target(
            name: "Day1",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day2",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day3",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day4",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day5",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day6",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day7",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt"), .process("test2.txt")]
        ),
        .target(
            name: "Day8",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day9",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day10",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day11",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day12",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day13",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day14",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt"), .process("test2.txt")]
        ),
        .target(
            name: "Day15",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
    ]
)
