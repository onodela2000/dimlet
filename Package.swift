// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Dimlet",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "Dimlet", targets: ["Dimlet"])],
    targets: [
        .target(name: "DimletCore"),
        .executableTarget(name: "Dimlet", dependencies: ["DimletCore"]),
        .testTarget(name: "DimletCoreTests", dependencies: ["DimletCore"])
    ]
)
