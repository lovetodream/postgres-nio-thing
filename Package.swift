// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PostgresNIOThing",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0-alpha"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(name: "PostgresNIOThing", dependencies: [
            .product(name: "Hummingbird", package: "hummingbird"),
            .product(name: "HummingbirdXCT", package: "hummingbird"),
            .product(name: "PostgresNIO", package: "postgres-nio"),
        ]),
    ]
)
