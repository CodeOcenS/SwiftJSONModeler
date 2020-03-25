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
}
struct YApiObject {
    /// 只有当type为object时提供
    var parentKey: String?
    var key: String!
    var mock: String = ""
    var type: YApiType!
    var des: String = ""
    var childs: [YApiObject] = []
}
