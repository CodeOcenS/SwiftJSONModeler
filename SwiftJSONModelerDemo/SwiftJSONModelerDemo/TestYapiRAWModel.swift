//
//  TestYapiRAWModel.swift
//  SwiftJSONModelerDemo
//
//  Created by Sven on 2020/3/27.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation
import Codable
import HandJSON
import HandyJSON

/// YApi RAW类型json数据
let yapiRAWData = """
{"type":"object","title":"empty object","properties":{"message":{"type":"string"},"code":{"type":"string"},"response":{"type":"object","properties":{"teachers":{"type":"array","items":{"type":"object","properties":{"name":{"type":"string","mock":{"mock":"Mrs Yang"},"description":"名字"},"subject":{"type":"string","mock":{"mock":"语文"},"description":"科目"},"phone":{"type":"string","mock":{"mock":"13459923098"},"description":"联系电话"}},"required":["name","subject","phone"]},"description":"老师"},"name":{"type":"string","description":"姓名"},"age":{"type":"integer","mock":{"mock":"18"},"description":"年龄"},"score":{"type":"number","mock":{"mock":"89.8"},"description":"综合成绩"},"likes":{"type":"array","items":{"type":"string","mock":{"mock":"英雄联盟"}},"description":"爱好"},"emergercyContact":{"type":"object","properties":{"name":{"type":"string"},"phone":{"type":"string","description":"联系电话"},"address":{"type":"string","description":"联系地址","mock":{"mock":"xx街道xx栋xx单元"}}},"description":"紧急联系人","required":["name","phone","address"]},"isBoy":{"type":"boolean","description":"是否为男孩"}},"required":["teachers","name","age","score","likes","emergercyContact","isBoy"]}},"required":["message","code","response"]}
"""

// 通过 YApi RAW数据转换Swift模型



/// <#描述#>
struct HKModel: HandJSON {
    
    var code: String = ""
    
    var response: HKResponseModel?
    
    var message: String = ""
}

/// <#描述#>
struct HKResponseModel: HandJSON {
    /// 老师
    var teachers: [HKTeachersModel] = []
    /// 爱好
    var likes: [String] = []
    /// 年龄
    var age: Int?
    /// 是否为男孩
    var isBoy: Bool?
    /// 紧急联系人
    var emergercyContact: HKEmergercyContactModel?
    /// 综合成绩
    var score: Double?
    /// 姓名
    var name: String = ""
}

/// <#描述#>
struct HKTeachersModel: HandJSON {
    /// 科目
    var subject: String = ""
    /// 名字
    var name: String = ""
    /// 联系电话
    var phone: String = ""
}

/// 紧急联系人
struct HKEmergercyContactModel: HandJSON {
    /// 联系地址
    var address: String = ""
    /// 联系电话
    var phone: String = ""
    
    var name: String = ""
}


