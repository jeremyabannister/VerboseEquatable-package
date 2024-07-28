//
//  Equatable_verboseEquals.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
extension Equatable {

    ///
    public func verboseEquals(
        _ other: Self
    ) throws {
        
        ///
        if self != other {
            
            ///
            throw VerboseEqualityError.unequal(
                lhsDescription: "\(self)",
                rhsDescription: "\(other)"
            )
        }
    }
}
