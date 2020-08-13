//
//  YApiObjectTest.swift
//  SwiftJSONModeler For XcodeTests
//
//  Created by Sven on 2020/8/13.
//  Copyright © 2020 Sven. All rights reserved.
//

import XCTest
@testable import SwiftJSONModeler_For_Xcode

class YApiObjectTest: XCTestCase {

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
    /// 测试将 Raw 数据解析按照路径解析 YapiObject
    func testYapiRawTransformObjedt() -> Void {
        let rawStr =
        """
        {"type":"object","title":"empty object","properties":{"person":{"type":"object","properties":{"name":{"type":"string","description":"姓名","mock":{"mock":"小明"}},"age":{"type":"integer","description":"年龄","mock":{"mock":"12"}},"school":{"type":"object","properties":{"address":{"type":"string","mock":{"mock":"xx街道xx号"},"description":"学校地址"},"schoolName":{"type":"string","description":"学校名字"}},"required":["address","schoolName"],"description":"学校"},"likes":{"type":"array","items":{"type":"string"},"description":"好友"},"teachers":{"type":"array","items":{"type":"object","properties":{"name":{"type":"string","description":"老师名字"},"subject":{"type":"string","description":"科目","mock":{"mock":"语文"}},"isMale":{"type":"boolean","description":"是否为男"}},"required":["name","subject","isMale"]}}},"required":["name","age","school","likes","teachers"],"description":"个人信息详情"}},"required":["person"]}

        """
        let helper = YApiHelper(paste: rawStr)
        helper.aimPath = "person"
        let yapiObject =  helper.compleObject
        XCTAssertNotNil(yapiObject)
    }
    
    /// yapi 基本类型（object, array, string, integer, number, boolean）兼容测试
    func testYapiBaseType() {
        let rawStr = """
            {"type":"object","title":"empty object","properties":{"data":{"type":"object","properties":{"stringValue":{"type":"string","description":"字符串类型","mock":{"mock":"字符串"}},"integerValue":{"type":"integer","description":"整型数据类型","mock":{"mock":"20"}},"numberValue":{"type":"number","description":"浮点数据类型","mock":{"mock":"15.5"}},"booleanValue":{"type":"boolean","description":"布尔类型","mock":{"mock":"true"}},"arrayValue":{"type":"array","items":{"type":"string","mock":{"mock":"数组字符串"}},"description":"数组类型"}},"required":["stringValue","integerValue","numberValue","booleanValue","arrayValue"]},"code":{"type":"string","mock":{"mock":"200"}}},"required":["data","code"]}
        """
        let yapiObjc = helper(raw: rawStr)
        XCTAssertNotNil(yapiObjc)
        let stringObjct = yapiObjc!.childs.filter{ $0.key == "stringValue" }
        XCTAssert(stringObjct.last!.type.swiftType() == "String")
        let integerObjct = yapiObjc!.childs.filter{ $0.key == "integerValue" }
        XCTAssert(integerObjct.last!.type.swiftType() == "Int")
        let numberObjct = yapiObjc!.childs.filter{ $0.key == "numberValue" }
        XCTAssert(numberObjct.last!.type.swiftType() == "Double")
        let booleanObjct = yapiObjc!.childs.filter{ $0.key == "booleanValue" }
        XCTAssert(booleanObjct.last!.type.swiftType() == "Bool")
    }
    
    /// 测试type 为非 Java基本类型,包含不规范基本数据（String, Integer）和其他自定义类型（Date, Other）
    func testOtherType() -> Void {
        let rawStr = """
        {"type":"object","title":"empty object","properties":{"data":{"type":"object","properties":{"StringValue":{"type":"String","description":"字符串类型","mock":{"mock":"字符串"}},"IntegerValue":{"type":"Integer","description":"整型数据类型","mock":{"mock":"20"}},"DateValue":{"type":"Date","description":"日期类型","mock":{"mock":"2020年08月01日"}},"OtherValue":{"type":"Other","description":"其他任意类型","mock":{"mock":"any"}},"arrayValue":{"type":"array","items":{"type":"string","mock":{"mock":"数组字符串"}},"description":"数组类型"}},"required":["stringValue","integerValue","numberValue","booleanValue","arrayValue"]},"code":{"type":"string","mock":{"mock":"200"}}},"required":["data","code"]}
        """
        let yapiObjc = helper(raw: rawStr)
        XCTAssertNotNil(yapiObjc)
        let stringObjct = yapiObjc!.childs.filter{ $0.key == "StringValue" }
        XCTAssert(stringObjct.last!.type.swiftType() == "String")
        let integerObjct = yapiObjc!.childs.filter{ $0.key == "IntegerValue" }
        XCTAssert(integerObjct.last!.type.swiftType() == "Int")
        let numberObjct = yapiObjc!.childs.filter{ $0.key == "DateValue" }
        XCTAssert(numberObjct.last!.type.swiftType() == "<#Undefined#>" && numberObjct.last!.typeRaw == "Date")
        let booleanObjct = yapiObjc!.childs.filter{ $0.key == "OtherValue" }
        XCTAssert(booleanObjct.last!.type.swiftType() == "<#Undefined#>" && booleanObjct.last!.typeRaw == "Other")
    }
    
    func helper(raw: String) -> YApiObject? {
        let helper = YApiHelper(paste: raw)
        helper.aimPath = "data"
        return helper.pathObject
    }

}
