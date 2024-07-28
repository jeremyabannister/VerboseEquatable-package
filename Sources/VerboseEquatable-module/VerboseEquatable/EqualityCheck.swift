//
//  EqualityCheck.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
public struct EqualityCheck<Subject>: ExpressionErgonomic {
    
    ///
    public var subject: Subject
    
    ///
    private var checks: [(Subject)throws->()] = []
    
    ///
    public init(_ subject: Subject) {
        self.subject = subject
    }
}

///
extension EqualityCheck {
    
    ///
    public static func mapping<
        NewValue: VerboseEquatable
    >(
        _ subject: Subject,
        _ transform: @escaping (Subject)->NewValue
    ) -> Self {
        
        ///
        Self(subject)
            .addingCheck { rhs in
                try transform(subject)
                    .equalityCheck
                    .checkAgainst(transform(rhs))
            }
    }
    
    ///
    public func compare<
        Value: VerboseEquatable
    >(
        _ keyPath: KeyPath<Subject, Value>,
        _ propertyName: String
    ) -> Self {
        
        ///
        self.addingKeyPathCheck(
            propertyName: propertyName,
            descriptionGenerator: { "\($0)" },
            keyPathCheck: { rhs in
                try subject[keyPath: keyPath].verboseEquals(rhs[keyPath: keyPath])
            }
        )
    }
}

///
private extension EqualityCheck {
    
    ///
    func addingKeyPathCheck(
        propertyName: String,
        descriptionGenerator: @escaping (Subject)->String,
        keyPathCheck: @escaping (Subject)throws->()
    ) -> Self {
        
        ///
        self.addingCheck { rhs in
            
            ///
            do {
                
                ///
                try keyPathCheck(rhs)
                
            ///
            } catch let error as VerboseEqualityError {
                
                ///
                throw error.nested(under: propertyName)
                
            ///
            } catch {
                
                ///
                throw VerboseEqualityError.unequal(
                    lhsDescription: descriptionGenerator(subject),
                    rhsDescription: descriptionGenerator(rhs)
                )
            }
        }
    }
}

///
extension EqualityCheck {
    
    ///
    public func addingCheck(
        _ check: @escaping (Subject)throws->()
    ) -> Self {
        
        ///
        self.mutated {
            $0
                .checks
                .append(check)
        }
    }
}

///
extension EqualityCheck {
    
    ///
    public func checkAgainst(
        _ other: Subject
    ) throws {
        
        ///
        try checks
            .reduce(into: VerboseEqualityError?.none) { fullError, check in
                
                ///
                do {
                    
                    ///
                    try check(other)
                    
                ///
                } catch let newError as VerboseEqualityError {
                    
                    ///
                    if fullError == nil {
                        
                        ///
                        fullError = .init(discrepancies: [])
                    }
                    
                    ///
                    fullError =
                        .init(
                            discrepancies:
                                fullError!
                                    .discrepancies
                                    .appending(
                                        newError
                                            .discrepancies
                                    )
                        )
                    
                ///
                } catch {
                    
                    ///
                    throw error
                }
            }
            .handle { error in
                
                ///
                if let error {
                    
                    ///
                    throw error
                }
            }
    }
}
