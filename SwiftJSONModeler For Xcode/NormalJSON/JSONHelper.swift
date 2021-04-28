//
//  JSONHelper.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/17.
//  Copyright © 2020 Sven. All rights reserved.
//
/// 将普通josn 转化为 YapiObject

import Foundation
import OrderJSON

public class JSONHelper {
    /// 复制的文本
    var paste: String = ""
    private var currentPath: [String] = []
    private var orderJSON: OrderJSON? {
        return try? JsonParser.parse(text: paste)
    }
    init(paste: String) {
        self.paste = paste
    }
    /// 将复制的文本 转化为 YApiObject 对象。
    func transform() -> YApiObject? {
        do {
            let dicJson = try JSONSerialization.jsonObject(with: paste.data(using: .utf8)!, options: .mutableLeaves)
            if let dic = dicJson as? [String: Any]{
                return objectOf(dic, key: "")
            } else if let arr = dicJson as? [Any] {
                return objectOf(arr, key: "")
            } else {
                return nil
            }
        } catch let e {
            print(e)
            ErrorCenter.shared.message = "json 序列化失败，请检查 json 数据"
            print(paste)
            return nil
    
        }
    }
    
    /// 字典转对象
    /// - Parameter dic: 字典数据
    private  func objectOf(_ dic: [String: Any], key: String) -> YApiObject {
        var childs: [YApiObject] = []
        currentPath.append(key)
        let subKeys = orderJSONSubKeysFor(path: currentPath)
        if subKeys.isEmpty {
            for (label, value) in dic {
                let child = typeOf(label, value: value, parentKey: key)
                childs.append(child)
            }
        } else {
            for key in subKeys {
                if let value = dic[key] {
                    let child = typeOf(key, value: value, parentKey: key)
                    childs.append(child)
                }
            }
        }
        currentPath.removeLast()
        let object = YApiObject(parentKey: nil, key: key, mock: "", type: YApiType.object, typeRaw: "Object", des: "", childs: childs)
        return object
    }
    private  func orderJSONSubKeysFor(path current:[String]) -> [String] {
        guard let json = orderJSON else {
            return []
        }
        return json.subKeysFor(keyPath: current)
    }
    /// 数组转对象
    /// - Parameter arry: 数据数组
    private func objectOf(_ arry: [Any], key:String) -> YApiObject {
        let type = YApiType.array
        guard  let first = arry.first  else {
            //ErrorCenter.shared.message = "json 序列化 数组第一个元素类型判断异常"
            let childType = YApiType.undefined
            let objct = YApiObject(parentKey: key, key: key, mock: "", type: childType, typeRaw: "<#Undefined#>", des: nil, childs: [])
            let arrObjct = YApiObject(parentKey: key, key: key, mock: "", type: type, typeRaw: "Array", des: nil, childs: [objct])
            return arrObjct
        }
        let arrObjct = YApiObject(parentKey: key, key: key, mock: "", type: type, typeRaw: "Array", des: nil, childs: [typeOf(key, value: first)])
        return arrObjct
    }
    /// 类型数据类型判断
    /// - Parameter value: 值
    private  func typeOf(_ key: String?, value: Any, parentKey: String? = nil) -> YApiObject {
        if value is NSNull {
            print("存在null")
            let type = YApiType.undefined
            let objct = YApiObject(parentKey: parentKey, key: key, mock: "", type: type, typeRaw: "NSNull", des: nil, childs: [])
            return objct
        } else if value is String {
            let type = YApiType.string
            let objct = YApiObject(parentKey: parentKey, key: key, mock: "", type: type, typeRaw: "String", des: nil, childs: [])
            return objct
        } else if value is Int {
            let type = YApiType.integer
            let objct = YApiObject(parentKey: parentKey, key: key, mock: "", type: type, typeRaw: "Int", des: nil, childs: [])
            return objct
        } else if value is Double {
            let type = YApiType.number
            let objct = YApiObject(parentKey: parentKey, key: key, mock: "", type: type, typeRaw: "Double", des: nil, childs: [])
            return objct
        } else if  value is Bool {
            let type = YApiType.boolean
            let objct = YApiObject(parentKey: parentKey, key: key, mock: "", type: type, typeRaw: "Bool", des: nil, childs: [])
            return objct
        } else if let arr =  value as? [Any] {
            return objectOf(arr, key: key ?? "")
        } else if let dic = value as? [String: Any]{
            return objectOf(dic, key: key ?? "")
        } else {
            ErrorCenter.shared.message = "json 格式异常，无法解析为 model"
            return YApiObject()
        }
    }
}
