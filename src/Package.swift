// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "IPD",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "IPD",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
    ]
)
