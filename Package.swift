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
            name: "Day01",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day02",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day03",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day04",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day05",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day06",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day07",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt"), .process("test2.txt")]
        ),
        .target(
            name: "Day08",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day09",
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
        .target(
            name: "Day16",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt"), .process("test2.txt")]
        ),
        .target(
            name: "Day17",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day18",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
        .target(
            name: "Day19",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt"), .process("test2.txt")]
        ),
        .target(
            name: "Day20",
            dependencies: ["Utils"],
            resources: [.process("input.txt"), .process("test.txt")]
        ),
    ]
)
