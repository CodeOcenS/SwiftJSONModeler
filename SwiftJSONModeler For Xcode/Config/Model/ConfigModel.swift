//
//  ConfigModel.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/2/7.
//  Copyright © 2021 Sven. All rights reserved.
//

import Foundation

class ConfigModel: Codable {
    var appVersion: String = ""
    var conform: String = ""
    var module: String = ""
    var prefix: String = ""
    var subffix = ""
    var isOptional: Bool = true
    /// 是否为隐式可选， 即 `Any!`
    var isImplicitlyOptional: Bool = false
    var isArrayDefaultEmpty: Bool = true
    /// 是否字符串类型默认为空 即 `""`
    var isStringDefaultEmpty: Bool = false
    var isShowYApiMock = false
    var yapiPath = ""
    /// 当前 token
    var yapiToken = ""
    var yapiHost = ""
    /// 备注
    var remark: String = ""
    /// 配置的多个 token
    var yapiTokenList: [YApiTokenModel] = []
}

extension ConfigModel {
    var parent: String {
        let confroms = stringToArray(conform)
        if confroms.isEmpty {
            return ""
        } else {
            return confroms.joined(separator: ", ")
        }
    }
    
    var moduleArr: [String] {
        return stringToArray(module)
    }
    
    private func stringToArray(_ str: String) -> [String] {
        guard !str.isEmpty else { return [] }
        return  str.components(separatedBy: ",")
    }
    
}

class YApiTokenModel: Codable {
    /// 项目名称
    var name: String = ""
    /// 项目 token
    var token: String = ""
}
