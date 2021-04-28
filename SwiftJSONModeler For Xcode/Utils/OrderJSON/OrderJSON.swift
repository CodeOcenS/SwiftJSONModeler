//
//  OrderJSON.swift
//  json
//
//  Created by mac on 2021/4/9.
//  git https://github.com/swiftdo/json
// 根据 json 构造特性手动解析， 仅限于转义压缩json

import Foundation

//data JValue = JString String
//            | JNumber Double
//            | JBool Bool
//            | JNull
//            | JObject [(String, JValue)]
//            | JArray [JValue]
//            | JInteger Integer
//  deriving (Eq, Ord, Read)


/// 类型和数据结构定义
public enum OrderJSON {
    case object([[String: OrderJSON]]) // 将字典改为数组，保证有序性
    case array([OrderJSON])
    case string(String)
    case double(Double)
    case int(Int)
    case bool(Bool)
    case null

    public init(_ value: Int) {
        self = .int(value)
    }

    public init(_ value: Double) {
        self = .double(value)
    }

    public init(_ value: [OrderJSON]) {
        self = .array(value)
    }

    public init(_ value: [[String: OrderJSON]]) {
        self = .object(value)
    }

    public init(_ value: String) {
        self = .string(value)
    }

    public init(_ value: Bool) {
        self = .bool(value)
    }
}

extension OrderJSON: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .string(v): return "String(\(v))"
        case let .double(v): return "Double(\(v))"
        case let .int(v): return "Int(\(v)"
        case let .bool(v): return "Bool(\(v))"
        case let .array(a): return "Array(\(a.description))"
        case let .object(o): return "Object(\(o.description))"
        case .null: return "Null"
        }
    }
}

extension OrderJSON: Equatable {
    public static func == (lhs: OrderJSON, rhs: OrderJSON) -> Bool {
        switch (lhs, rhs) {
        case let (.string(l), .string(r)): return l == r
        case let (.double(l), .double(r)): return l == r
        case let (.int(l), .int(r)): return l == r
        case let (.bool(l), .bool(r)): return l == r
        case let (.array(l), .array(r)): return l == r
        case let (.object(l), .object(r)): return l == r
        case (.null, .null): return true
        default: return false
        }
    }
}
