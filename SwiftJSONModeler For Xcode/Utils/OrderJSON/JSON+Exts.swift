//
//  JSON+Exts.swift
//  json
//
//  Created by Sven on 2021/4/20.
//

import Foundation

extension JSON {
    // 返回 Any 基础类型类型
    func any() -> Any {
        switch self {
        case .string(let value):
            return value
        case .object(let value):
            return value.map { (key, value) -> [String: Any] in
                [key: value.any()]
            }
        case .array(let value):
            return value.map{ $0.any() }
        case .double(let value):
            return value
        case .int(let value):
            return value
        case .bool(let value):
            return value
        case .null:
            return NSNull()
        }
    }
}
