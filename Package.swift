// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "OpenClawControl",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "OpenClawControl", targets: ["OpenClawControl"])
    ],
    targets: [
        .executableTarget(
            name: "OpenClawControl",
            path: "Sources/OpenClawControl"
        )
    ]
)
