//
//  HomeworkDay4Tests.swift
//  HomeworkDay4Tests
//
//  Created by Fumiaki Kobayashi on 2020/05/26.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import XCTest


class HomeworkDay4Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testMySample() {
        let mySample = MySample()
        let add = mySample.add(a: 2, b: 3)
        print(add)
        XCTAssertEqual(add, 5)
    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
