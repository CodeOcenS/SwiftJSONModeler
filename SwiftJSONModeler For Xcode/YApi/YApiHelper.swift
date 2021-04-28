//
//  YApiHelper.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
import OrderJSON

enum YApiKeys: String {
    case type
    case properties
    case des = "description"
}

/// 将Yapi RAW数据解析为目标YApiObject
class YApiHelper {
    private var pasteJSON: String
    var pathObject: YApiObject? {
        return pathObjectTransform()
    }

    /// 按照path解析 `""`表示最外层, 默认值
    var aimPath: String = ""

    private lazy var originJOSN: [String: Any]? = {
        transformToDic()
    }()

    private lazy var customJSON: OrderJSON? = {
        try? JsonParser.parse(text: pasteJSON)
    }()

    /// 用于 OrderJOSN  key 寻找的
    private var currentPath: [String] = []

    init(paste: String) {
        self.pasteJSON = paste
    }

    private func getPathObjects(path: String, from object: YApiObject) -> YApiObject? {
        guard !path.isEmpty else {
            return object
        }
        let pathArr = path.components(separatedBy: ".")

        func searchObject(key: String, in object: YApiObject) -> YApiObject? {
            if object.key == key {
                return object
            } else {
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
            } else {
                ErrorCenter.shared.message = "寻找\(path)目标失败"
                return nil
            }
        }
        return search
    }

    // type 类型 如果不含type则为完整模型
    private func apiType(of dic: [String: Any]) -> YApiType? {
        guard let typeStr = dic["type"] as? String else {
            return nil
        }
        return YApiType.of(typeStr)
    }

    private func objectsOf(key parent: String, properties: [String: Any]) -> [YApiObject] {
        currentPath.append(parent)
        print("当前路径:\(currentPath)")
        let subKeys = customJSON?.yapiSubKeysFor(keyPath: currentPath) ?? []
        print("子健:\(subKeys)")
        var objectArr: [YApiObject] = []
        if subKeys.isEmpty {
            logError("无法通过 OrderJSON 解析获取 subkey")
            print("\(pasteJSON)")
            // 直接解析
            for item in properties {
                if let value = item.value as? [String: Any] {
                    if let object = self.object(key: item.key, json: value) {
                        var temp = object
                        temp.parentKey = parent
                        objectArr.append(temp)
                    }
                } else {
                    ErrorCenter.shared.message = "存在不确定类型\(parent)"
                }
            }
        } else {
            // 使用与 json key 顺序一致解析
            for key in subKeys {
                if let value = properties[key] as? [String: Any] {
                    if let object = self.object(key: key, json: value) {
                        var temp = object
                        temp.parentKey = parent
                        objectArr.append(temp)
                    }
                } else {
                    ErrorCenter.shared.message = "存在不确定类型\(parent)"
                }
            }
        }
        currentPath.removeLast()
        return objectArr
    }

    /// 获取某一具体类型的对象
    private func object(key: String = "", json: [String: Any]) -> YApiObject? {
        guard let type = apiType(of: json) else {
            ErrorCenter.shared.message = "key数据格式异常\n:\(json)"
            return nil
        }
        var object = YApiObject()
        object.key = key
        object.type = type
        object.typeRaw = ((json["type"] as? String) ?? "")
        switch type {
        case .object:
            if let properties = json["properties"] as? [String: Any] {
                object.childs = self.objectsOf(key: key, properties: properties)
            } else {
                ErrorCenter.shared.message = "json 对象\(key) properties异常"
                return nil
            }

        case .array:
            if let items = json["items"] as? [String: Any], let type = items["type"] as? String {
                object.des = json["description"] as? String ?? ""
                let apiType = YApiType.of(type)
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
        case .integer, .boolean, .string, .number, .undefined:
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

// MARK: - Get

extension YApiHelper {
    /// 从
    private func transformToDic() -> [String: Any]? {
        let paste = pasteJSON
        guard let data = paste.data(using: .utf8) else {
            ErrorCenter.shared.message = "string 转换 data 异常"
            return nil
        }

        // 使用系统解析
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
    private func pathObjectTransform() -> YApiObject? {
        guard let dic = originJOSN else {
            return nil
        }
        var apiObj: YApiObject?
        if apiType(of: dic) != nil {
            apiObj = object(json: dic)
        } else {
            var ob = YApiObject()
            ob.childs = objectsOf(key: "", properties: dic)
            ob.type = .object
            ob.typeRaw = "object"
            apiObj = ob
        }
        guard let object = apiObj else {
            return nil
        }
        return getPathObjects(path: aimPath, from: object)
    }
}
