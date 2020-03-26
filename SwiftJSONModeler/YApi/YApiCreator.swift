//
//  YApiCreator.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/25.
//  Copyright © 2020 Sven. All rights reserved.
//

import AppKit
import XcodeKit

extension String {
     func upperCaseFirst() -> String {
        let temp = self
        guard !self.isEmpty else {
            return temp
        }
        let firstIndex = temp.startIndex
        let replaceEndIndex = temp.index(after: startIndex)
        let firstLetter = temp.prefix(1)
        let upper = firstLetter.uppercased()
        let new =  temp.replacingCharacters(in: firstIndex..<replaceEndIndex, with: upper)
        return new
    }
}

/// 将YApiObject生成row lines
class YApiCreator {
    
    private lazy var parent: String = {
        let config = ConfigUserDefault.shared.getConfig()
        let confrom = config.confrom
        if confrom.isEmpty {
            return ""
        } else {
            return confrom.joined(separator: ", ")
        }
    }()
    
    /// 遵循
    private lazy var importModule: [String] = {
        ConfigUserDefault.shared.getConfig().module
    }()
    
    var invocation: XCSourceEditorCommandInvocation
    var objectHelper: YApiHelper!
    var lines: NSMutableArray!
    var isShowMock: Bool = false
    
    private var errorCenter = ErrorCenter.shared
    private var pasteText: String {
        guard let paste = NSPasteboard.general.string(forType: .string) else {
            errorCenter.message = "获取复制内容失败"
            return ""
        }
        guard !paste.isEmpty else {
            errorCenter.message = "复制内容为空"
            return ""
        }
        return paste
    }
    private var creatObjects: Set<YApiObject> = []
    /// 只包含对象的行，不包含个struct或class关键字
    private var objectLines: [(yapiObject:YApiObject, lines:[String])] = []
    init(invocation: XCSourceEditorCommandInvocation) {
        self.invocation = invocation
        let buffer = invocation.buffer
        lines = buffer.lines
        objectHelper = YApiHelper(paste: pasteText)
        getPathObject()
    }
    
    private func getPathObject() -> Void {
        objectHelper.aimPath = "data" //设置获取data下数据
        guard let object = objectHelper.pathObject else {
            return
        }
        creatObjects.insert(object)
        lineObject(self.creatObjects.first!)
    }
    
   private func lineObject(_ object: YApiObject) -> Void {
        var aimObject: YApiObject = object
       
        if object.type! == .object {
            aimObject = object
        }else  if object.type! == .array {
            if let firstOb = object.childs.first, firstOb.type! == .object {
                aimObject = firstOb
            }else {
                return
            }
        }else {
            errorCenter.message = "\(#function)对象类型异常"
            return
        }
        var objectLines: [String] = []
        for child in aimObject.childs {
            if let line = lineRow(from: child) {
                objectLines.append(contentsOf: line)
            }
        }
        self.objectLines.append((object,objectLines))
        self.creatObjects.remove(object)
        if self.creatObjects.count != 0 {
            lineObject(self.creatObjects.first!)
        }
    }
    /// 返回注释和每一行的
    private func lineRow(from object: YApiObject) -> [String]? {
        let type = object.type!
        var swiftType = type.swiftType()
        switch type {
        case .array:
            if let subObject = object.childs.first {
                let subObjectType = subObject.type!
                if subObjectType == .object {
                    creatObjects.insert(subObject)
                    swiftType = "[\(subObject.key?.upperCaseFirst() ?? "<#Undefiend#>")]"
                } else {
                    swiftType = "[\(subObjectType.swiftType())]"
                }
            } else {
                return nil
            }
        case .object:
            creatObjects.insert(object)
            swiftType = object.key!.upperCaseFirst()
        case .integer, .string, .number, .boolean:
            break
        }
        let comment = "/// \(object.des)\(isShowMock ? "\tMock:\(object.mock)" : "")"
        let line = "var \(object.key!): \(swiftType)?"
        return [comment,line]
    }
    func getModels() -> [String] {
        var models: [String] = []
        for object in objectLines {
            models.append(contentsOf: model(commandIdentifier: invocation.commandIdentifier, yapiObject: object.yapiObject, yapiLines: object.lines))
        }
        return models
    }
    /// 获取完整模型定义
     private func model(commandIdentifier: CommandId, yapiObject: YApiObject, yapiLines: [String]) -> [String] {
        var name: String = "<#Model#>"
        if yapiObject.key != nil {
            name = yapiObject.key!.upperCaseFirst()
        }
        var des: String = "<#描述#>"
        if !yapiObject.des.isEmpty {
            des = yapiObject.des
        }
        var keyword = keyStruct
        if commandIdentifier == classFromRAWCommand {
            keyword = keyClass
        } else if commandIdentifier == classFromRAWCommand {
            keyword = keyStruct
        }
        
        var objctLines: [String] = []
        objctLines.append("/// \(des)")
        if parent.isEmpty {
            objctLines.append("\(keyword)  \(name) {")
        } else {
            objctLines.append("\(keyword) \(name): \(parent) {")
        }
        let lines = yapiLines.map{ "\t\($0)" }
        objctLines.append(contentsOf: lines)
        if commandIdentifier == classFromRAWCommand, parent.contains("HandyJSON") {
            objctLines.append("")
            objctLines.append("\trequired init() { }")
        }
        objctLines.append("}")
        objctLines.append("\n")
        return objctLines
    }
}
