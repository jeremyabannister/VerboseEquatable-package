// swift-tools-version: 5.10

///
import PackageDescription


///
let package = Package(
    name: "VerboseEquatable-package",
    products: [
        
        ///
        .library(
            name: "VerboseEquatable-module",
            targets: ["VerboseEquatable-module"]
        ),
    ],
    dependencies: [
        
        ///
        .package(
            url: "https://github.com/jeremyabannister/subscript-collection-safely",
            "0.1.1" ..< "0.2.0"
        ),
        
        ///
        .package(
            url: "https://github.com/jeremyabannister/ValueType-package",
            "0.1.0" ..< "0.2.0"
        ),
    ],
    targets: [
        
        ///
        .target(
            name: "VerboseEquatable-module",
            dependencies: [
                "subscript-collection-safely",
                .product(name: "ValueType-module", package: "ValueType-package")
            ]
        ),
        
        ///
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
