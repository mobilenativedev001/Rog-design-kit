// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "RogersDesignSystem",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Tokens", targets: ["Tokens"]),
        .library(name: "Components", targets: ["Components"]),
        .library(name: "UIKitCompat", targets: ["UIKitCompat"]),
    ],
    targets: [
        .target(
            name: "Tokens",
            path: "Sources/Tokens",
            publicHeadersPath: nil
        ),
        .target(
            name: "Core",
            dependencies: ["Tokens"],
            path: "Sources/Core"
        ),
        .target(
            name: "Components",
            dependencies: ["Core", "Tokens"],
            path: "Sources/Components"
        ),
        .target(
            name: "UIKitCompat",
            dependencies: ["Components", "Core"],
            path: "Sources/UIKitCompat"
        )
    ]
)
