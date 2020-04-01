//
//  YApiObject.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
// 可能存在的YApi类型，通过插件导入的
private let key_Long = "Long"
private let key_String = "String"
private let key_Integer = "Integer"
private let key_integer = "integer"
private let key_long = "long"
/// YApi标准数据类型
/// - Important: 请务必使用类方法 of()进行类型初始化
enum YApiType: String {
    case object = "object"
    case array = "array"
    case integer = "integer"
    case boolean = "boolean"
    case string = "string"
    case number = "number"
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
        default:
            return "<#Undefined#>"
        }
    }
    
    static func of(_ string: String) -> Self? {
        if let apiType = YApiType(rawValue: string) {
            return apiType
        } else {
            switch string {
            case key_Long, key_long, key_Integer:
                return .integer
            case key_String:
                return .string
            default:
                return nil
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
    var des: String = ""
    var childs: [YApiObject] = []
    

}
