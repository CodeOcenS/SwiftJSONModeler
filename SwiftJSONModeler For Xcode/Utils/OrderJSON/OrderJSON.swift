//
//  OrderJSON.swift
//  
//
//  Created by Sven on 2021/4/20.
//

import Foundation
/// 手动在最外层添加 `data`字段
struct OrderJSON {
    private var original: String
    private var data: String {
        "{\"data\":" + original + "}"
    }
    init(_ input: String) {
        self.original = input
    }
    /// 第一次 key 始终为 `data`
    func dictionary() -> [String: Any]? {
        do {
            if let result = try JsonParser.parse(text: data) {
                let anyValue = result.any()
                if let dic = (anyValue as? [[String: Any]])?.first  {
                    return dic
                }
                return nil
            } else {
                return nil
            }
        } catch  {
            print(error)
            return nil
        }
    }
}
