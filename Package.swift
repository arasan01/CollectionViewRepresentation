// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CollectionViewRepresentation",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CollectionViewRepresentation",
            targets: ["CollectionViewRepresentation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/woxtu/UIHostingConfigurationBackport", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "CollectionViewRepresentation",
            dependencies: ["UIHostingConfigurationBackport"]),
        .testTarget(
            name: "CollectionViewRepresentationTests",
            dependencies: ["CollectionViewRepresentation"]),
    ]
)
