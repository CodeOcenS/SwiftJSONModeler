//
//  YApiObject.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
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
