//
//  YApiObject.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
// 可能存在的YApi类型，通过插件导入的
private let keyJavaDouble = "double"
private let keyJavaFloat = "float"
private let keyJavaLong = "long"
private let keyJavaInt = "int"
/// YApi标准数据类型
/// - Important: 请务必使用类方法 of()进行类型初始化
enum YApiType: String {
    case object = "object"
    case array = "array"
    case integer = "integer"
    case boolean = "boolean"
    case string = "string"
    case number = "number"
    case undefined
    /// 对于Swift基本类型。object和arry为Undefined 则需要自行构造
    func swiftType() -> String {
        switch self {
        case .integer:
            return "Int"
        case .boolean:
            return "Bool"
        case .string:
            return "String"
        case .number:
            return "Double"
        case .undefined:
            return "<#Undefined#>"
        default:
            return "<#Undefined#>"
        }
    }
    /// 规范化 yapi 类型
    static func of(_ string: String) -> Self {
        let lowerStr = string.lowercased()  // 由于java存在基本数据类型和对象类型。
        if let apiType = YApiType(rawValue: lowerStr) {
            return apiType
        } else {
            switch lowerStr {
            case keyJavaLong:
                return .integer
            case keyJavaFloat, keyJavaDouble:
                return .number
            case keyJavaInt:
                return .integer
            default:
                return .undefined
            }
        }
    }
}
struct YApiObject: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
//    static func == (lhs: YApiObject, rhs: YApiObject) -> Bool {
//        return lhs.key == rhs.key && lhs.parentKey == rhs.parentKey && lhs.des == rhs.des
//    }
    
    /// 只有当type为object时提供
    var parentKey: String?
    var key: String!
    var mock: String = ""
    var type: YApiType!
    /// 原始 类型
    var typeRaw: String = ""
    var des: String?
    var childs: [YApiObject] = []
    

}
