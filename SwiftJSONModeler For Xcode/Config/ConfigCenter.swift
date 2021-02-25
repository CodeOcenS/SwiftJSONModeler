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
    
    init() {
        config = Self.readConfig()
    }

}
// MARK: - Private Static Method

private extension ConfigCenter {
     static func readConfig() -> ConfigModel {
        let fileManager = FileManager.default
        guard let data = fileManager.contents(atPath: configPath) else {
            return writeDefaultConfig()
        }
        
        let decoder = CleanJSONDecoder()
        guard let model = try? decoder.decode(ConfigModel.self, from: data) else {
            return writeDefaultConfig()
        }
        return model
    }
    
    static func writeDefaultConfig() -> ConfigModel {
        let defaultConfig = ConfigModel()
        let propertyListEncoder = PropertyListEncoder()
        propertyListEncoder.outputFormat = .xml
        
        let plistData = try? propertyListEncoder.encode(defaultConfig)
        _ = FileManager.default.createFile(atPath: configPath, contents: plistData, attributes: nil)
        return defaultConfig
    }
}
