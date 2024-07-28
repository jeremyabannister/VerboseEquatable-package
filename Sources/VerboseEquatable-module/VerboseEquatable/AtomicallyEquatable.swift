//
//  AtomicallyEquatable.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
public protocol AtomicallyEquatable: VerboseEquatable { }

///
extension AtomicallyEquatable {
    
    ///
    public var equalityCheck: EqualityCheck<Self> {
        EqualityCheck(self)
            .addingCheck { rhs in
                if self != rhs {
                    throw VerboseEqualityError.unequal(
                        lhsDescription: "\(self)",
                        rhsDescription: "\(rhs)"
                    )
                }
            }
    }
}
