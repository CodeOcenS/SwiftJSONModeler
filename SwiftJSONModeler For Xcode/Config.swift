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
    var conformArr: [String] {
        stringToArray(conform)
    }
    var parent: String {
        let parents = conformArr
        if parents.isEmpty {
            return ""
        }else {
            return parents.joined(separator: ", ")
        }
    }
    var moduleArr: [String] {
        stringToArray(module)
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
    var isNotOptional: Bool {
        set{
            userDefault.set(newValue, forKey: Key.isNotOptional.rawValue)
        } get {
           return userDefault.bool(forKey: Key.isNotOptional.rawValue)
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
    /// 数组默认是否定义不为空，默认为空即false
    var arrayIsDefaultNotEmpty: Bool {
           set{
               userDefault.set(newValue, forKey: Key.arrayIsDefaultNotEmpty.rawValue)
           } get {
              return userDefault.bool(forKey: Key.arrayIsDefaultNotEmpty.rawValue)
           }
       }
    
    /// 是否显示Mock， 默认不显示
    var isShowYApiMock: Bool {
        set{
            userDefault.set(newValue, forKey: Key.isShowYApiMock.rawValue)
        } get {
            return userDefault.bool(forKey: Key.isShowYApiMock.rawValue)
        }
    }
    var yapiPath: String {
        set{
            userDefault.set(newValue, forKey: Key.yapiPath.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.yapiPath.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    var yapiToken: String {
        set{
            userDefault.set(newValue, forKey: Key.yapiToken.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.yapiToken.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    var yapiHost: String {
        set{
            userDefault.set(newValue, forKey: Key.yapiHost.rawValue)
        } get {
            if let value = userDefault.value(forKey: Key.yapiHost.rawValue), let valueStr = value as? String {
                return valueStr
            } else {
                return ""
            }
        }
    }
    
    var userDefault = UserDefaults(suiteName: appGroupe)! // if suiteName the same as bundleId or "NSGloabDomain", wil be nil
    
    func stringToArray(_ str: String) -> [String] {
        guard !str.isEmpty else { return [] }
        return  str.components(separatedBy: ",")
    }
}

extension Config {
    enum Key: String {
        case conform = "conform"
        case module = "module"
        case prefix = "prefix"
        case subffix = "subffix"
        case isNotOptional = "isNotOptional"
        case isImplicitlyOptional = "isImplicitlyOptional"
        case arrayIsDefaultNotEmpty = "arrayIsDefaultNotEmpty"
        case isShowYApiMock = "isShowYApiMock"
        case yapiPath = "yapiPath"
        case yapiToken = "yapiToken"
        case yapiHost = "yapiHost"
    }
}
