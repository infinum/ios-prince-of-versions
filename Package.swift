// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrinceOfVersions",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "PrinceOfVersions",
            type: .dynamic,
            targets: ["PrinceOfVersions"]
        )
    ],
    targets: [
        .target(
            name: "PrinceOfVersions",
            dependencies: [],
            resources: [.copy("SupportingFiles/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "PrinceOfVersionsTests",
            dependencies: ["PrinceOfVersions"]
        )
    ]
)
