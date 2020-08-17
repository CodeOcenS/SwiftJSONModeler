//
//  TestJSONModel.swift
//  SwiftJSONModelerDemo
//
//  Created by Sven on 2020/3/27.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
import HandyJSON

/// 普通json 数据
let normalJSON  = """
{
    "title": "第一层 json",
    "stringValue": "字符串值",
    "intValue": 58,
    "doubleValue": 18.2,
    "nullValue": null,
    "boolValue": true,
    "subJson": {
        "title": "第二层 json",
        "stringValue": "字符串值"
    },
    "arrayValue1": [
        "value1",
        "value2",
        "value3"
    ],
    "arrayValue2": [{
        "title": "数组包含子 json",
        "intValue": 12,
        "boolValue": false
    }]
}
"""

// MARK: - 插件创建模型


///
struct HKModel: HandyJSON {
    
    var arrayValue2: [HKArrayValue2Model] = []
    
    var nullValue: <#NSNull#>?
    
    var intValue: Int?
    
    var arrayValue1: [String] = []
    
    var title: String?
    
    var stringValue: String?
    ///
    var subJson: HKSubJsonModel?
    
    var doubleValue: Double?
    
    var boolValue: Int?
}

///
struct HKArrayValue2Model: HandyJSON {
    
    var title: String?
    
    var boolValue: Int?
    
    var intValue: Int?
}

///
struct HKSubJsonModel: HandyJSON {
    
    var title: String?
    
    var stringValue: String?
}

