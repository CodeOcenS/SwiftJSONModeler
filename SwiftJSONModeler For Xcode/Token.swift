//
//  Token.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/21.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
/// 格式 title:token
typealias TokenDescription = String

struct Token: CustomStringConvertible {
    var title: String
    var token: String
    
    var description: String {
        return "\(title):\(token)"
    }
    
    init(title: String, token: String) {
        self.title = title
        self.token = token
    }
    /// 从字符串初始化
    /// - Parameter titleToken: 格式必须为 title:token
    init(titleToken: TokenDescription) {
        let string = titleToken.components(separatedBy: ":")
        title = string[0]
        token = string[1]
    }
}
/// 本地化
extension Token {
    static func updateUserDefault(for tokens: [Token]) -> Void {
        let userDefault = UserDefaults.standard
        let value = tokens.map{ $0.description }
        userDefault.set(value, forKey: UserDefaults.Key.tokens.rawValue)
    }
    
   static func getTokenFormUserDefault() -> [Token] {
        guard let tokenStrs = UserDefaults.standard.array(forKey: UserDefaults.Key.tokens.rawValue) as? [TokenDescription] else {
            return []
        }
        return tokenStrs.map { Token(titleToken: $0) }
    }
}
