// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-context-protocol",
    platforms: [.macOS("15.0"), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(
            name: "ContextProtocol",
            targets: ["ContextProtocol"]),
    ],
    dependencies: [
        .package(url: "https://github.com/samalone/websocket-actor-system.git", branch: "main"),
        .package(url: "https://github.com/kevinhermawan/swift-json-schema.git", branch: "main")
    ],
    targets: [
        .target(
            name: "ContextProtocol",
            dependencies: [
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
                .product(name: "JSONSchema", package: "swift-json-schema")
            ]
        ),
        .executableTarget(
            name: "ContextServer",
            dependencies: [
                "ContextProtocol",
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
            ]
        ),
        .executableTarget(
            name: "ContextClient",
            dependencies: [
                "ContextProtocol",
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
            ]
        ),
        .testTarget(
            name: "ContextProtocolTests",
            dependencies: ["ContextProtocol"]
        )
    ]
)
