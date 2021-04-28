//
//  OrderJSON+Yapi.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/4/27.
//  Copyright © 2021 Sven. All rights reserved.
//

import Foundation


func logError(_ msg: String = "错误", functionName: String = #function){
    print("")
    print(#line,functionName,#fileID)
    print("_____Error:\(msg)")
}
/// 解析出 YApi 路径某个路径下的子 key
public extension OrderJSON {
    /// 返回YApi Raw json中当前 key 的子键数组（具有顺序）
    ///
    /// 原理，由于 Yapi json 类型为`object`字段和格式一致。
    func yapiSubKeysFor(keyPath: [String]) -> [String] {
        let tempPath = keyPath.filter{ $0 != ""}
        guard case .object(_) = self else {
            return []
        }
        guard !tempPath.isEmpty else {
            return searchKeysIn(self)
        }
        let paths = tempPath //: [String] = keyPath.components(separatedBy: ".")
        return keysFor(paths: paths, in: self)
    }
    
    private func keysFor(paths: [String], in json: OrderJSON) -> [String] {
        guard !paths.isEmpty else {
            logError("异常错误，请检查")
            return [] // 应该永远不会发生
        }
        let currentKey = paths.first!
        let nextPaths = Array(paths.dropFirst())
        guard let currentOrderJSON = searchJSONFor(key: currentKey, in: json) else {
             logError("找不到key=\(currentKey)的 OrderJSON 对象")
            return []
        }
        if nextPaths.isEmpty {
            // 结束
            return searchKeysIn(currentOrderJSON)
        } else {
          return keysFor(paths: nextPaths, in: currentOrderJSON)
        }
    }
    
    private func searchJSONFor(key: String, in json: OrderJSON) -> OrderJSON? {
        guard case .object(let objc) = json else {
            logError("\(key)不是JSON.object类型")
            return nil
        }
        guard let properties = orderJSONFor(key: YApiKeys.properties.rawValue, in: objc)  else {
            logError("\(key)的 properties 字段不存在")
            return nil
        }
        guard case .object(let aim) = properties else {
            logError("\(key)下 properties不是JSON.object类型")
            return nil
        }
        guard let keyObject = orderJSONFor(key: key, in: aim) else {
            logError("\(key)下 properties 不存在该 key 对象")
            return nil
        }
        return keyObject
    }
    private func searchKeysIn(_ json: OrderJSON) -> [String] {
        guard case .object(let objc) = json else {
            return []
        }
        guard let properties = orderJSONFor(key: YApiKeys.properties.rawValue, in: objc) else {
            return []
        }
        guard case .object(let aim) = properties else {
            return []
        }
        var keys: [String] = []
        aim.forEach { (value) in
            keys.append(value.keys.first!)
        }
        return keys
    }
    
    private func orderJSONFor(key: String, in arr:[[String: OrderJSON]]) -> OrderJSON? {
        return arr.first(where: {$0.first!.key == key })?.first?.value
    }
}
