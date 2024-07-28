//
//  VerboseEquatable_tests.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
final class VerboseEquatable_tests: SingleTypeTestCase {
    
    ///
    typealias Subject = VerboseEquatable
    
    ///
    struct Dummy:
        VerboseEquatable,
        ExpressionErgonomic {
        
        ///
        var foo: Foo
        var bar: String
        var baz: Int?
        
        ///
        var equalityCheck: EqualityCheck<Self> {
            EqualityCheck(self)
                .compare(\.foo, "foo")
                .compare(\.bar, "bar")
                .compare(\.baz, "baz")
        }
        
        ///
        struct Foo: VerboseEquatable {
            
            ///
            var bar: Int
            var baz: Bool
            var bop: [Bop]
            
            ///
            var equalityCheck: EqualityCheck<Self> {
                EqualityCheck(self)
                    .compare(\.bar, "bar")
                    .compare(\.baz, "baz")
                    .compare(\.bop, "bop")
            }
            
            ///
            struct Bop: VerboseEquatable {
                
                ///
                var a: Int
                var b: String
                
                ///
                var equalityCheck: EqualityCheck<Self> {
                    EqualityCheck(self)
                        .compare(\.a, "a")
                        .compare(\.b, "b")
                }
            }
        }
    }
    
    ///
    func test_existence () {
        func proof<T: VerboseEquatable>(t: T) { }
    }
    
    ///
    func test_foo() throws {
        
        ///
        func test(
            _ lhs: Dummy,
            _ rhs: Dummy,
            _ expected: VerboseEqualityError?
        ) throws {
            
            ///
            do {
                
                ///
                try lhs.verboseEquals(rhs)
                
            ///
            } catch {
                
                ///
                guard let expected else {
                    throw "The values were expected to compare as equal, but an error was thrown: \(error).".asErrorMessage()
                }
                
                ///
                if let verboseEqualityError = error as? VerboseEqualityError {
                    
                    ///
                    try verboseEqualityError
                        .assertEqual(to: expected)
                    
                ///
                } else {
                    
                    ///
                    throw "Expected an error of type `\(VerboseEqualityError.self)` but caught error of type `\(type(of: error))`: \(error)".asErrorMessage()
                }
            }
        }
        
        ///
        func error(
            _ path: [String],
            _ lhs: String,
            _ rhs: String
        ) -> VerboseEqualityError {
            .init(
                discrepancies: [
                    .init(
                        keyPath: path,
                        lhsDescription: lhs,
                        rhsDescription: rhs
                    )
                ]
            )
        }
        
        ///
        try Dummy(
            foo:
                .init(
                    bar: 0,
                    baz: true,
                    bop: [
                        .init(a: 7, b: "yep"),
                        .init(a: 0, b: "zero")
                    ]
                ),
            bar: "a",
            baz: 3
        )
            .handle { dummy in
                try test(
                    dummy,
                    dummy,
                    nil
                )
                try test(
                    dummy,
                    dummy.setting(\.bar, to: "this"),
                    error(["bar"], "a", "this")
                )
                try test(
                    dummy,
                    dummy.setting(\.baz, to: nil),
                    error(["baz", "isNil"], "false", "true")
                )
                try test(
                    dummy,
                    dummy.setting(\.foo.bop[0].a, to: 9),
                    error(["foo", "bop", "[0]", "a"], "7", "9")
                )
            }
    }
}
