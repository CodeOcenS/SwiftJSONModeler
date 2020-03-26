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
/// 将Yapi RAW数据解析为目标YApiObject
class YApiHelper {
    private var pasteJSON: String
    var pathObject: YApiObject? {
        return object(from: aimPath, dic: originJOSN)
    }
    /// 按照path解析
    var aimPath: String = ""
    var compleObject: YApiObject? {
        return object(from: "", dic: originJOSN)
    }
    var originJOSN: [String: Any]? {
        return check(from: pasteJSON)
    }
    
    init(paste: String) {
        self.pasteJSON = paste
    }
    /// 从
    private func check(from paste: String) -> [String: Any]? {
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
        return jsonDic
        
    }
    /// 获取目标路径下的 YapiOject
    private func object(from path: String ,dic: [String: Any]?) -> YApiObject? {
        guard let dic = dic else {
            return nil
        }
        var apiObj: YApiObject?
        if apiType(of: dic) != nil {
            apiObj = object(json: dic)
        } else {
            var ob = YApiObject()
            ob.childs = objectsOf(key:"", properties: dic)
            ob.type = .object
            apiObj = ob
        }
        guard let object = apiObj else {
            return nil
        }
        return getPathObjects(path: path, from: object)
    }
    
    private func getPathObjects(path: String, from object: YApiObject) -> YApiObject? {
        guard !path.isEmpty else { return object }
        let pathArr = path.components(separatedBy: ".")
        
        func searchObject(key:String, in object: YApiObject)  -> YApiObject? {
            if object.key == key  {
                return object
            }else {
                var subObjec: YApiObject?
                for child in object.childs {
                    if let sub = searchObject(key: key, in: child) {
                        subObjec = sub
                    }
                }
                return subObjec
            }
        }
        var search = object
        for path in pathArr {
            if let aimObject = searchObject(key: path, in: search) {
                search = aimObject
            }else {
                ErrorCenter.shared.message = "寻找\(path)目标失败"
                return nil
            }
        }
        return search
    }
    
    // type 类型 如果不含type则为完整模型
    private func apiType(of dic:[String: Any]) -> YApiType? {
        guard let typeStr = dic["type"] as? String, let type = YApiType(rawValue: typeStr) else {
            return nil
        }
        return type
    }
    private func objectsOf(key parent: String,  properties: [String: Any]) -> [YApiObject] {
        var objectArr: [YApiObject] = []
        for item in properties {
            if let value = item.value as? [String: Any]{
                if let object = self.object(key: item.key, json: value) {
                    var temp = object
                    temp.parentKey = parent
                    objectArr.append(temp)
                }
            } else {
                ErrorCenter.shared.message = "存在不确定类型\(parent)"
            }
        }
        return objectArr
    }
    private func object(key: String = "",  json: [String: Any]) -> YApiObject? {
        guard let type = apiType(of: json) else {
            ErrorCenter.shared.message = "key数据格式异常"
            return nil
        }
        var object = YApiObject()
        object.key = key
        object.type = type
        switch type {
        case .object:
            if let properties = json["properties"] as? [String: Any] {
                object.childs = self.objectsOf(key: key, properties: properties)
            }else {
                ErrorCenter.shared.message = "json 对象\(key) properties异常"
                return nil
            }
            
        case .array:
            if let items = json["items"] as? [String: Any], let type = items["type"] as? String, let apiType = YApiType(rawValue: type) {
                object.des = json["description"] as? String ?? ""
                if apiType == .object {
                    if let arrObject = self.object(key: key, json: items) {
                         object.childs = [arrObject]
                    } else {
                       object.childs = []
                    }
                } else {
                    let childs = self.object(json: items)
                    object.childs = childs == nil ? [] : [childs!]
                }
            } else {
                ErrorCenter.shared.message = "数组\(key)异常，可能不存在items或type"
                return nil
            }
        case .integer, .boolean, .string, .number:
            if let mockJson = json["mock"] as? [String: Any], let mock = mockJson["mock"] as? String {
                object.mock = mock
            }
            
        }
        if let des = json["description"] as? String {
            object.des = des
        }
        return object
    }
    
    
    
}
