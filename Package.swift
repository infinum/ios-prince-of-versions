// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrinceOfVersions",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "PrinceOfVersions",
            type: .dynamic,
            targets: ["PrinceOfVersions"]
        )
    ],
    targets: [
        .target(name: "PrinceOfVersions", dependencies: []),
        .testTarget(name: "PrinceOfVersionsTests", dependencies: ["PrinceOfVersions"])
    ]
)
