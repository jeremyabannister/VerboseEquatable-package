//
//  Foundation+extensions_tests.swift
//  
//
//  Created by Jeremy Bannister on 3/24/23.
//

///
extension Set_tests {
    
    ///
    func test_typeName() throws {
        try Subject.typeName.assertEqual(to: "Set<Int>")
    }
    
    ///
    func test_equalityCheck() throws {
        try Subject().verboseEquals([])
        try Subject([1]).verboseEquals([1])
        try Subject([0, -4, 15]).verboseEquals([-4, 15, 0])
        try expectDiscrepancies(
            (["count"], "0", "1"),
            (["(contains 1)"], "false", "true"),
            between: [],
            and: [1]
        )
        try expectDiscrepancies(
            (["count"], "1", "0"),
            (["(contains 5)"], "true", "false"),
            between: [5],
            and: []
        )
        try expectDiscrepancies(
            (["(contains -10)"], "true", "false"),
            (["(contains 5)"], "false", "true"),
            between: [-10],
            and: [5]
        )
        try expectDiscrepancies(
            (["count"], "2", "1"),
            (["(contains 1)"], "true", "false"),
            between: [1, 2],
            and: [2]
        )
        try expectDiscrepancies(
            (["(contains 1)"], "true", "false"),
            (["(contains 4)"], "false", "true"),
            between: [1, 2, 3],
            and: [2, 3, 4]
        )
    }
}

///
private extension Set_tests {
    
    ///
    func expectDiscrepancies(
        _ discrepancies: ([String], String, String)...,
        between lhs: Subject,
        and rhs: Subject
    ) throws {
        
        ///
        do {
            
            ///
            try lhs
                .verboseEquals(rhs)
            
            ///
            throw "Was expecting discrepancies but found none.".asErrorMessage()
            
        ///
        } catch let error as VerboseEqualityError {
            
            ///
            try error
                .assert(
                    \.discrepancies,
                    equals: discrepancies.map {
                        .init(
                            keyPath: $0.0,
                            lhsDescription: $0.1,
                            rhsDescription: $0.2
                        )
                    }
                )
            
        ///
        } catch {
            
            ///
            throw error
        }
    }
}
