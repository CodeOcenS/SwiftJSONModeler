//
//  ConfigUserDefault.swift
//  JSONSwiftModelApp
//
//  Created by Sven on 2020/1/22.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation

private let appGroupe = "com.lifu.JSONSwiftModel"

class ConfigUserDefault: NSObject {
    static let shared: ConfigUserDefault = ConfigUserDefault()
    var userDefault: UserDefaults
    private override init() {
        userDefault = UserDefaults(suiteName: appGroupe)!
    }
    
    func set(confrom: [String], module: [String]) {
        userDefault.set(confrom, forKey: ConfigUserDefault.Key.confrom.rawValue)
        userDefault.set(module, forKey: ConfigUserDefault.Key.module.rawValue)
        userDefault.synchronize()
    }
    
    func getConfig() -> (confrom: [String], module: [String]) {
        return (userDefault.value(forKey: ConfigUserDefault.Key.confrom.rawValue) != nil ? userDefault.value(forKey: ConfigUserDefault.Key.confrom.rawValue) as! [String] : [],
                userDefault.value(forKey: ConfigUserDefault.Key.module.rawValue) != nil ? userDefault.value(forKey: ConfigUserDefault.Key.module.rawValue) as! [String] : [])
    }
}

extension ConfigUserDefault {
    enum Key: String {
        case confrom = "confrom"
        case module  = "module"
    }
}
