// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YoutubeSpamEliminator",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Enchan1207/Serializable", from: "1.0.0"),
        .package(url: "https://github.com/Enchan1207/YoutubeKit", from: "2.4.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "YoutubeSpamEliminator",
            dependencies: [
                "YoutubeKit",
                "Serializable"
            ]),
        .testTarget(
            name: "YoutubeSpamEliminatorTests",
            dependencies: ["YoutubeSpamEliminator"]),
    ]
)
