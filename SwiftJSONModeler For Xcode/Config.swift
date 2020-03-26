//
//  Config.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/3/26.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation

private let appGroupe = "SwiftJSONModeler"

class Config {
    var conform: String {
        set{
            userDefault.set(newValue, forKey: Key.conform.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.conform.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    var module: String {
        set{
            userDefault.set(newValue, forKey: Key.module.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.module.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    var prefix: String {
        set{
            userDefault.set(newValue, forKey: Key.prefix.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.prefix.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    var subffix: String {
        set{
            userDefault.set(newValue, forKey: Key.subffix.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.subffix.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    var optionalType: OptionalType {
        set{
            userDefault.set(newValue.rawValue, forKey: Key.optionalType.rawValue)
        } get {
            let value = userDefault.integer(forKey: Key.optionalType.rawValue)
            if let type = OptionalType(rawValue: value) {
                return type
            } else {
                return .all
            }
        }
    }
    /// 是否隐式可选， 默认为显示可选
    var isImplicitlyOptional: Bool {
        set{
            userDefault.set(newValue, forKey: Key.isImplicitlyOptional.rawValue)
        } get {
           return userDefault.bool(forKey: Key.isImplicitlyOptional.rawValue)
        }
    }
    /// 是否显示Mock， 默认不显示
    var isShowYApiMock: Bool {
        set{
            userDefault.set(newValue, forKey: Key.conform.rawValue)
        } get {
            return userDefault.bool(forKey: Key.isShowYApiMock.rawValue)
        }
    }
    
    var userDefault = UserDefaults(suiteName: appGroupe)! // if suiteName the same as bundleId or "NSGloabDomain", wil be nil
}
extension Config {
    enum OptionalType: Int {
        /// 所有类型可选
        case all = 0
        /// 根据json值决定，有值可选
        case some = 1
        /// 所有都不可选
        case not = 2
    }
}

extension Config {
    enum Key: String {
        case conform = "conform"
        case module = "module"
        case prefix = "prefix"
        case subffix = "subffix"
        case optionalType = "optionalType"
        case isImplicitlyOptional = "isImplicitlyOptional"
        case isShowYApiMock = "isShowYApiMock"
    }
}
