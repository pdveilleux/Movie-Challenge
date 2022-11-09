// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieAPI",
    platforms: [
            .iOS(.v15), .macOS(.v10_14)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MovieAPI",
            targets: ["MovieAPI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apollographql/apollo-ios", from: "1.0.3"),
        .package(name: "GeneratedAPI", path: "./GeneratedAPI")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MovieAPI",
            dependencies: [
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "GeneratedAPI", package: "GeneratedAPI")
            ]),
        .testTarget(
            name: "MovieAPITests",
            dependencies: ["MovieAPI"]),
    ]
)
