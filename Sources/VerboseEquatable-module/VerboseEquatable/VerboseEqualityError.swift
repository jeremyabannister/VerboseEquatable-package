//
//  VerboseEqualityError.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
public struct VerboseEqualityError:
    ValueType,
    Codable,
    CustomStringConvertible,
    Error {
    
    ///
    public var discrepancies: [Discrepancy]
    
    ///
    public init(discrepancies: [Discrepancy]) {
        self.discrepancies = discrepancies
    }
}

///
extension VerboseEqualityError {
    
    ///
    public var description: String {
        discrepancies
            .map { $0.description }
            .joined(separator: "\n")
            .prepending("\n")
    }
}

///
extension VerboseEqualityError {
    
    ///
    public func nested(
        under propertyName: String
    ) -> VerboseEqualityError {
        
        ///
        self.mutated { nestedResult in
            
            ///
            discrepancies
                .indices
                .forEach { index in
                    
                    ///
                    let unnestedKeyPath = discrepancies[index].keyPath
                    
                    ///
                    nestedResult.discrepancies[index].keyPath = [propertyName] + unnestedKeyPath
                }
        }
    }
}

///
extension VerboseEqualityError {
    
    ///
    public static func unequal(
        lhsDescription: String,
        rhsDescription: String
    ) -> Self {
        
        ///
        .init(
            discrepancies: [
                .init(
                    keyPath: [],
                    lhsDescription: lhsDescription,
                    rhsDescription: rhsDescription
                )
            ]
        )
    }
}

///
extension VerboseEqualityError {
    
    ///
    public struct Discrepancy:
        ValueType,
        Codable,
        CustomStringConvertible {
        
        ///
        public var keyPath: [String]
        public var lhsDescription: String
        public var rhsDescription: String
        
        ///
        public init(
            keyPath: [String],
            lhsDescription: String,
            rhsDescription: String
        ) {
            
            ///
            self.keyPath = keyPath
            self.lhsDescription = lhsDescription
            self.rhsDescription = rhsDescription
        }
    }
}

///
extension VerboseEqualityError.Discrepancy {
    
    ///
    public var description: String {
        "\(keyPath.joined(separator: ".")): \(lhsDescription), \(rhsDescription)"
    }
}
