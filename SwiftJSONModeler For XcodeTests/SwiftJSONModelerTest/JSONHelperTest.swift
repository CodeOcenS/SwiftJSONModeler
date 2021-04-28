//
//  JSONHelperTest.swift
//  SwiftJSONModeler For XcodeTests
//
//  Created by Sven on 2020/8/17.
//  Copyright © 2020 Sven. All rights reserved.
//

import XCTest
@testable import SwiftJSONModeler_For_Xcode

class JSONHelperTest: XCTestCase {
    private let multiJson =
        """
        {
            "title": "第一层 json",
            "stringValue": "字符串值",
            "intValue": 58,
            "doubleValue": 18.2,
            "nullValue": null,
            "boolValue": true,
            "subJson": {
                "title": "第二层 json",
                "stringValue": "字符串值"
            },
            "arrayValue1": [
                "value1",
                "value2",
                "value3"
            ],
            "arrayValue2": [{
                "title": "数组包含子 json",
                "intValue": 12,
                "boolValue": false
            }]
        }
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
    
    /// 测试异常 json 格式
    func testAbnormalJSON() -> Void {
        let json = """
        {
            "title": "这不是一个正确的 json",
            "property1": "第一个属性" // 不加逗号
            property: "" // 没用引号
        }
        """
        let helper = JSONHelper(paste: json)
        let object = helper.transform()
        XCTAssertNil(object)
    }
    
    /// 测试 第一层为数组 json
    func testArrayJSON() {
        let json =
        """
        [
            "value1",
            "value2",
            "value3"
        ]
        """
        let helper = JSONHelper(paste: json)
        let object = helper.transform()
        XCTAssertNotNil(object)
        XCTAssert(object!.childs.first!.type == YApiType.string, "数组类型应该为 String")
    }
    
    /// 测试 数组为空情况
    func testEmptyArray() {
        let json =
        """
        {
            "title": "空数组",
            "emptyArray": []
        }
        """
        let helper = JSONHelper(paste: json)
        let object = helper.transform()
        XCTAssertNotNil(object)
        XCTAssert(object!.childs.filter { $0.key == "emptyArray" }.first!.childs.first!.type == YApiType.undefined, "数组类型应该为 Undefined")
    }
    
    /// 测试 单层 接送
    func testSingleJSON() -> Void {
        let json =
        """
        {
        "title": "第一层 json",
        "stringValue": "字符串值",
        "intValue": 58,
        "doubleValue": 18.2,
        "nullValue": null,
        "boolValue": true
        }
        """
        let helper = JSONHelper(paste: json)
        let object = helper.transform()
        XCTAssertNotNil(object)
        let objc = object!
       
        XCTAssertNotNil(objc.childs.filter { $0.key == "stringValue" }.first)
        XCTAssertNotNil(objc.childs.filter { $0.key == "intValue" }.first)
        XCTAssertNotNil(objc.childs.filter { $0.key == "boolValue" }.first)
        XCTAssertNotNil(objc.childs.filter { $0.key == "nullValue" }.first)
        XCTAssertNotNil(objc.childs.filter { $0.key == "doubleValue" }.first)

    }
    
    /// 测试多层嵌套 json
    func testMultiLevelJSON() -> Void {
        let json = multiJson
        
        let helper = JSONHelper(paste: json)
        let transformObject = helper.transform()
        XCTAssertNotNil(transformObject)
        guard let object = transformObject else {
            return
        }
        let subJsonArr = object.childs.filter{ $0.key == "subJson" }
        XCTAssertNotNil(subJsonArr.first)
        guard let subJson = subJsonArr.first else {
            return
        }
        XCTAssert(subJson.childs.count == 2, "subJson 属性数量为2")
        XCTAssert(object.childs.filter { $0.key == "arrayValue1" }.first!.childs.first!.type == YApiType.string, "arrayValue1 数组类型应该为 String")
        XCTAssert(object.childs.filter { $0.key == "arrayValue2" }.first!.childs.first!.type == YApiType.object, "arrayValue2 数组类型应该为 object")
        
        // key 顺序测试
        let orderKeys = ["title", "stringValue", "intValue", "doubleValue", "nullValue", "boolValue", "arrayValue1", "arrayValue2"]
        
        let currentKeys = object.childs.compactMap {$0.parentKey}
        XCTAssertTrue(orderKeys == currentKeys, "json key 顺序应该一致")
        
    }

}
