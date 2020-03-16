//
//  YApiHelper.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
enum Keys: String {
    case type = "type"
    case properties = "properties"
    case des = "description"
}

class YApiHelper {
    var object: YApiObject?
    init(paste: String) {
        self.object = data(from: paste)
    }
    /// 从
    private func data(from paste: String) -> YApiObject? {
        guard let data = paste.data(using: .utf8) else {
            ErrorCenter.shared.message = "string 转换 data 异常"
            return nil
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
            ErrorCenter.shared.message = "json 序列化异常"
            return nil
        }
        
        guard let jsonDic = jsonObject as? [String: Any] else {
            ErrorCenter.shared.message = "json 转为字典失败"
            return nil
        }
        
        // type 类型 如果不含type则为完整模型
        func apiType(of dic:[String: Any]) -> YApiType? {
            guard let typeStr = dic["type"] as? String, let type = YApiType(rawValue: typeStr) else {
                return nil
            }
            return type
        }
        
        func objects(key: String = "",  properties: [String: Any]) -> [YApiObject] {
            var objectArr: [YApiObject] = []
            if apiType(of: properties) == .object {
                var object = YApiObject()
                let childs = objects(key: key, properties: properties[Keys.properties.rawValue] as! [String: Any])
                object.type = .object
                object.key = key
                object.des = (properties[Keys.des.rawValue] as? String) ?? ""
                object.childs = childs
                return [object]
            }
            for item in properties {
                var object = YApiObject()
                let key = item.key
                object.key = key
                if let sub = item.value as? [String: Any] {
                    let type = apiType(of: sub)
                    if type == .object {
                        let properties = sub[Keys.des.rawValue] as! [String: Any]
                        object.childs.append(contentsOf: objects(key: key, properties: properties))
                    } else if type == .array {
                        let properties = (sub["items"] as! [String: Any])["properties"] as! [String: Any]
                        object.childs.append(contentsOf: objects(key: key, properties: properties))
                    } else {
                        if let mockDic = sub["mock"] as? [String: Any], let mock = mockDic["mock"] as? String {
                            object.mock = mock
                        }
                    }
                    if let typeStr = sub["type"] as? String, let type = YApiType(rawValue: typeStr) {
                        object.type = type
                    }
                    if let desStr = sub[Keys.des.rawValue] as? String {
                        object.des = desStr
                    }
                }
                objectArr.append(object)
            }
            return objectArr
        }
        let apiData = objects(key: "", properties: jsonDic).first
        print("____获得apiData:\(apiData)")
        return apiData
    }
}
