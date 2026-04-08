// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Jsong",
    platforms: [.iOS("16.0")],
    products: [
        .iOSApplication(
            name: "Jsong",
            targets: ["Jsong"],
            bundleIdentifier: "com.jsong.app",
            teamIdentifier: "",
            displayVersion: "1.0.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .bird),
            accentColor: .presetColor(.red),
            supportedDeviceFamilies: [.pad, .phone],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft
            ],
            appCategory: .education
        )
    ],
    targets: [
        .executableTarget(
            name: "Jsong",
            path: "Sources"
        )
    ]
)
