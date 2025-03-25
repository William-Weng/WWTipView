// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWTipView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWTipView", targets: ["WWTipView"]),
    ],
    targets: [
        .target(name: "WWTipView", resources: [.process("Material/Media.xcassets"), .process("Xib")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
