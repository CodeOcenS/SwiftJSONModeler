//
//  SwiftJSONModeler_For_XcodeTests.swift
//  SwiftJSONModeler For XcodeTests
//
//  Created by Sven on 2020/3/28.
//  Copyright © 2020 Sven. All rights reserved.
//

import XCTest
@testable import SwiftJSONModeler_For_Xcode

class SwiftJSONModeler_For_XcodeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testConfig() {
        let config = Config()
        let conform = config.conform
        config.conform = "AnyConform"
        XCTAssert(config.conform == "AnyConform")
        config.conform = conform
    }

}
