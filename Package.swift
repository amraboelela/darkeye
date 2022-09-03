// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "DarkEye",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/amraboelela/VaporCommon.git", .branch("main")),
        .package(url: "https://github.com/amraboelela/DarkEyeCore.git", .branch("main")),
    ],
    
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "VaporCommon", package: "VaporCommon"),
                .product(name: "DarkEyeCore", package: "DarkEyeCore"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
