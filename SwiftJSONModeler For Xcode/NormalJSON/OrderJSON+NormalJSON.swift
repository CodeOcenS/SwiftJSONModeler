//
//  OrderJSON+NormalJSON.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/4/28.
//  Copyright © 2021 Sven. All rights reserved.
//

import Foundation
/// 解析出普通 json 的有序子键
extension OrderJSON {
    
    /// 返回json中当前 key 的子键数组（具有顺序）
    /// - Parameter keyPath: 路径数组，如`data.info` -> ["data","info"], 最顶层为空数组
    /// - Returns: 子健数组
    func subKeysFor(keyPath: [String]) -> [String] {
        let tempPath = keyPath.filter{ $0 != ""}
        guard case .object(_) = self else {
            return []
        }
        guard !tempPath.isEmpty else {
            return searchKeysIn(self)
        }
        let paths = tempPath
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
        guard let keyObject = orderJSONFor(key: key, in: objc) else {
            logError("\(key)下不存在该 OrderJSON 对象")
            return nil
        }
        return keyObject
    }
    private func searchKeysIn(_ json: OrderJSON) -> [String] {
        if case .object(let objc) = json  {
            // json 对象
           return searchKeysInObject(objc)
        }
        if case .array(let objc) = json, let first = objc.first {
            // 数组
            if case .object(let items) = first {
                return searchKeysInObject(items)
            }
        }
        return []
    }
    
    private func searchKeysInObject(_ keyObjects:[[String: Any]]) -> [String] {
        var keys: [String] = []
        keyObjects.forEach { (value) in
            keys.append(value.keys.first!)
        }
        return keys
    }
    
    private func orderJSONFor(key: String, in arr:[[String: OrderJSON]]) -> OrderJSON? {
        return arr.first(where: {$0.first!.key == key })?.first?.value
    }
}

