//
//  Foundation+extensions.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
extension Bool: AtomicallyEquatable { }
extension Data: AtomicallyEquatable { }
extension Double: AtomicallyEquatable { }
extension Int: AtomicallyEquatable { }
extension String: AtomicallyEquatable { }
extension UInt: AtomicallyEquatable { }
extension UUID: AtomicallyEquatable { }

///
extension ClosedRange: VerboseEquatable
    where Bound: VerboseEquatable {
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        EqualityCheck(self)
            .compare(\.lowerBound, "lowerBound")
            .compare(\.upperBound, "upperBound")
    }
}

///
extension Optional: VerboseEquatable
    where Wrapped: VerboseEquatable {
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        EqualityCheck(self)
            .compare(\.isNil, "isNil")
            .addingCheck {
                
                ///
                if let lhs = self,
                   let rhs = $0 {
                    
                    ///
                    try lhs.verboseEquals(rhs)
                }
            }
    }
}

///
extension Array: VerboseEquatable
    where Element: VerboseEquatable {
    
    ///
    public static var typeName: String { "Array<\(Element.self)>" }
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        EqualityCheck(self)
            .compare(\.count, "count")
            .mutated { check in
                self.indices.forEach { index in
                    check = check.compare(\.[safely: index], "[\(index)]")
                }
            }
    }
}

///
extension Dictionary: VerboseEquatable
    where Key: VerboseEquatable,
          Value: VerboseEquatable {
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        EqualityCheck(self)
            .compare(\.keys, "keys")
            .mutated { check in
                self.forEach { key, value in
                    check = check.compare(\.[key], "[\(key)]")
                }
            }
    }
}

///
extension Dictionary.Keys: VerboseEquatable
    where Key: VerboseEquatable {
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        .mapping(self, { Set($0) })
    }
}

///
extension Set: VerboseEquatable
    where Element: VerboseEquatable {
    
    ///
    public static var typeName: String { "Set<\(Element.self)>" }
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        EqualityCheck(self)
            .compare(\.count, "count")
            .addingCheck { rhs in
                
                ///
                let uniqueToLHS = self.subtracting(rhs)
                let uniqueToRHS = rhs.subtracting(self)
                
                ///
                func mapToDiscrepancies(
                    _ set: Self,
                    isLHS: Bool
                ) -> [VerboseEqualityError.Discrepancy] {
                    
                    ///
                    set
                        .map {
                            .init(
                                keyPath: ["(contains \($0))"],
                                lhsDescription: "\(isLHS)",
                                rhsDescription: "\(!isLHS)"
                            )
                        }
                }
                
                ///
                if uniqueToLHS.isNotEmpty.or(uniqueToRHS.isNotEmpty) {
                    
                    ///
                    throw VerboseEqualityError(
                        discrepancies:
                            mapToDiscrepancies(
                                uniqueToLHS,
                                isLHS: true
                            )
                                +
                            mapToDiscrepancies(
                                uniqueToRHS,
                                isLHS: false
                            )
                    )
                }
            }
    }
}
