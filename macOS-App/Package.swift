// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PromptBar",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "PromptBar", targets: ["PromptBar"])
    ],
    targets: [
        .executableTarget(
            name: "PromptBar",
            path: "Sources/PromptBar"
        )
    ]
)
