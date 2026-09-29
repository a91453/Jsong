// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Jsong",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "JsongCore", targets: ["JsongCore"]),
        .library(name: "JsongPresentation", targets: ["JsongPresentation"]),
    ],
    targets: [
        .target(name: "JsongCore"),
        .target(name: "JsongPresentation", dependencies: ["JsongCore"]),
        .testTarget(name: "JsongCoreTests", dependencies: ["JsongCore"]),
        .testTarget(name: "JsongPresentationTests", dependencies: ["JsongPresentation"]),
    ]
)
