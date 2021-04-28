//
//  OrderJSON+YApiTest.swift
//  SwiftJSONModeler For XcodeTests
//
//  Created by Sven on 2021/4/27.
//  Copyright © 2021 Sven. All rights reserved.
//

import XCTest
@testable import SwiftJSONModeler_For_Xcode
class OrderJSONYApiTest: XCTestCase {
    private let testStr = """
            {\"type\":\"object\",\"title\":\"empty object\",\"properties\":{\"data\":{\"type\":\"object\",\"properties\":{\"stringValue\":{\"type\":\"string\",\"description\":\"字符串类型\",\"mock\":{\"mock\":\"字符串\"}},\"integerValue\":{\"type\":\"integer\",\"description\":\"整型数据类型\",\"mock\":{\"mock\":\"20\"}},\"numberValue\":{\"type\":\"number\",\"description\":\"浮点数据类型\",\"mock\":{\"mock\":\"15.5\"}},\"booleanValue\":{\"type\":\"boolean\",\"description\":\"布尔类型\",\"mock\":{\"mock\":\"true\"}},\"arrayValue\":{\"type\":\"array\",\"items\":{\"type\":\"string\",\"mock\":{\"mock\":\"数组字符串\"}},\"description\":\"数组类型\"}},\"required\":[\"stringValue\",\"integerValue\",\"numberValue\",\"booleanValue\",\"arrayValue\"]},\"code\":{\"type\":\"string\",\"mock\":{\"mock\":\"200\"}}},\"required\":[\"data\",\"code\"]}
        """
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
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    private func transformStringToArray(_ string: String) -> [String] {
        if string.isEmpty {
            return []
        }
        return string.components(separatedBy: ",")
    }
    /// 测试自定解析 Yapi数据， 且 key 顺序与 json 一致
    func testYApiJSON() {
        let str = testStr
        let path = "data"
        let rootPath = ""
        guard let jsonObject = try? JsonParser.parse(text: str) else {
            XCTAssertFalse(true)
            return
        }
        let rootKeys = jsonObject.yapiSubKeysFor(keyPath: transformStringToArray(rootPath))
        XCTAssertTrue(rootKeys == ["data","code"])
        let dataKeysWhenRight = ["stringValue", "integerValue", "numberValue", "booleanValue", "arrayValue"]
        let dataKeys = jsonObject.yapiSubKeysFor(keyPath: transformStringToArray(path))
        XCTAssertTrue(dataKeys == dataKeysWhenRight)
        
        let stringValuePath = "stringValue"
        let stringValueKeys = jsonObject.yapiSubKeysFor(keyPath: transformStringToArray(stringValuePath))
        XCTAssertTrue(stringValueKeys.isEmpty)
    }
}
