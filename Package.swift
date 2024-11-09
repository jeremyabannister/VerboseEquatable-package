// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "VerboseEquatable-package",
    products: [
        .library(
            name: "VerboseEquatable-module",
            targets: ["VerboseEquatable-module"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/jeremyabannister/subscript-collection-safely",
            .upToNextMinor(from: "0.1.4")
        ),
        .package(
            url: "https://github.com/jeremyabannister/ValueType-package",
            .upToNextMinor(from: "0.1.6")
        ),
    ],
    targets: [
        .target(
            name: "VerboseEquatable-module",
            dependencies: [
                "subscript-collection-safely",
                .product(name: "ValueType-module", package: "ValueType-package")
            ]
        ),
        .testTarget(
            name: "VerboseEquatable-module-tests",
            dependencies: [
                "VerboseEquatable-module",
                .product(
                    name: "ValueTypeTestToolkit",
                    package: "ValueType-package"
                ),
            ]
        ),
    ]
)
