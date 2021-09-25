// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AppearanceNotifier",
    products: [
        .executable(name: "AppearanceNotifier", targets: ["AppearanceNotifier"]),
    ],
    dependencies: [
        .package(url: "git@github.com:JohnSundell/ShellOut.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "AppearanceNotifier",
            dependencies: ["ShellOut"]
        ),
        .testTarget(
            name: "AppearanceNotifierTests",
            dependencies: ["AppearanceNotifier"]
        ),
    ]
)
