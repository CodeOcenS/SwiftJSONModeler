//
//  ConfigCenter.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/2/25.
//  Copyright © 2021 Sven. All rights reserved.
//

import Foundation
import CleanJSON
/// 配置存在路径
let configPath =  (NSHomeDirectory() as NSString).appendingPathComponent("Config.plist")

class ConfigCenter {
    static let `default` = ConfigCenter()
    var config: ConfigModel
    
    private init() {
        config = Self.readConfig()
    }
    @discardableResult
    func save() -> Bool {
       return Self.writeConfig(config)
    }

    
}
// MARK: - Private Static Method

private extension ConfigCenter {
     static func readConfig() -> ConfigModel {
        let fileManager = FileManager.default
        guard let data = fileManager.contents(atPath: configPath) else {
            return writeDefaultConfig()
        }
        
        let decoder = PropertyListDecoder()//CleanJSONDecoder()
        do {
            let model = try decoder.decode(ConfigModel.self, from: data)
            return model
        } catch let error {
            print("读取 plist 转 model 失败")
            print(error)
            return writeDefaultConfig()
        }
    }
    
    static func writeDefaultConfig() -> ConfigModel {
        let defaultConfig = ConfigModel()
        writeConfig(defaultConfig)
        return defaultConfig
    }
    @discardableResult
    static func writeConfig(_ config: ConfigModel) -> Bool {
//        let propertyListEncoder = PropertyListEncoder()
//        propertyListEncoder.outputFormat = .xml
//        let plistData = try? propertyListEncoder.encode(config)
        guard let data = try? config.toJSON() else {
            return false
        }
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
            return false
        }
        let isSuccess =  dic.write(toFile: configPath, atomically: true)
        //let isSuccess = FileManager.default.createFile(atPath: configPath, contents: data, attributes: nil)
        return isSuccess
    }
}
