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
    private let baseTypeRaw =
    """
    {"type":"object","title":"empty object","properties":{"data":{"type":"object","properties":{"stringValue":{"type":"string","description":"字符串类型","mock":{"mock":"字符串"}},"integerValue":{"type":"integer","description":"整型数据类型","mock":{"mock":"20"}},"numberValue":{"type":"number","description":"浮点数据类型","mock":{"mock":"15.5"}},"booleanValue":{"type":"boolean","description":"布尔类型","mock":{"mock":"true"}},"arrayValue":{"type":"array","items":{"type":"string","mock":{"mock":"数组字符串"}},"description":"数组类型"}},"required":["stringValue","integerValue","numberValue","booleanValue","arrayValue"]},"code":{"type":"string","mock":{"mock":"200"}}},"required":["data","code"]}
    """
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
//        let config = Config()
//        let conform = config.conform
//        config.conform = "AnyConform"
//        XCTAssert(config.conform == "AnyConform")
//        config.conform = conform
    }
    
    func testOrderJSON() {
        let data = baseTypeRaw.data(using: .utf8)
        
    }
    
    

}
