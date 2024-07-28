//
//  VerboseEquatable.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
public protocol VerboseEquatable: Equatable {
    
    ///
    static var typeName: String { get }
    
    ///
    var equalityCheck: EqualityCheck<Self> { get }
}

///
extension VerboseEquatable {
    
    ///
    public static var typeName: String { "\(Self.self)" }
    
    ///
    public func verboseEquals(
        _ other: Self
    ) throws {
        
        ///
        try self
            .equalityCheck
            .checkAgainst(other)
    }
}
