//
//  SourceEditorCommand.swift
//  LExt
//
//  Created by Sven on 2020/1/21.
//  Copyright © 2020 Sven. All rights reserved.
//

import AppKit
import XcodeKit

let configCommand = "config"
let structFromJSONCommand = "structFromJSON"
let classFromJSONCommand = "classFromJSON"
let structFromRAWCommand = "structFromRAW"
let classFromRAWCommand = "classFromRAW"
let structFromYApiIdCommand = "structFromYApiId"
let classFromYApiIdCommand = "classFromYApiId"

let domain = "SwiftJSONModeler"
let keyImport = "import"
let keyClass = "class"
let keyStruct = "struct"

typealias CommandId = String

extension Notification.Name {
    static let errorNotification = Notification.Name("errorNoti")
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    let config = Config()
    private var completionHandler: (Error?) -> Void = { _ in  }
    /// 复制版内容
    var pasteboardTest: String {
        guard let paste = NSPasteboard.general.string(forType: .string) else {
            return ""
        }
        guard !paste.isEmpty else {
            return ""
        }
        return paste
    }
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        print("启动插件")
        self.completionHandler = completionHandler
        addErrorNoti()
        // TODO: json多层解析
        let commandIdentifier = invocation.commandIdentifier
        if commandIdentifier == configCommand {
            NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/SwiftJSONModeler For Xcode.app"))
            completionHandler(nil)
        } else if commandIdentifier == classFromRAWCommand || commandIdentifier == structFromRAWCommand {
            handleInvocation(invocation, raw: pasteboardTest, completionHandler: completionHandler)
            
        } else if commandIdentifier == classFromJSONCommand || commandIdentifier == structFromJSONCommand {
            handleInvocation(invocation, handler: completionHandler)
        } else if commandIdentifier == classFromYApiIdCommand || commandIdentifier == structFromYApiIdCommand {
            YApiRequest.data(id: pasteboardTest) { [weak self](raw) in
                if let raw = raw {
                    self?.handleInvocation(invocation, raw: raw, completionHandler: completionHandler)
                }else {
                    completionHandler(nil)
                }
            }
        }
    }
    /// 通过 YApi RAW数据转模
    private func handleInvocation(_ invocation: XCSourceEditorCommandInvocation, raw: String, completionHandler: @escaping (Error?) -> Void) {
        let yapiCreator = YApiCreator(invocation: invocation, pasteText: raw)
        let models = yapiCreator.getModels()
        var lines = invocation.buffer.lines
        lines.addObjects(from: models)
        importModel(lines: &lines)
        completionHandler(nil)
    }
    /// 通过json 转模
    private func handleInvocation(_ invacation: XCSourceEditorCommandInvocation, handler: (Error?) -> Void) {
        let buffer = invacation.buffer
        var line = buffer.lines
        // importModel(lines: &line)
        if pasteboardTest.isEmpty {
            handler(error(msg: "复制文本不能为空"))
            return
        }
        let lines = linesFrom(paste: pasteboardTest)
        switch lines {
        case .failure(let error):
            handler(error)
        case .success(let l):
            let objectLines = objectLine(commandIdentifier: invacation.commandIdentifier, line: l)
            addLines(origin: &line, new: objectLines, invocation: invacation)
            importModel(lines: &line)
            handler(nil)
        }
    }
}

// MARK: - 添加通知

private extension SourceEditorCommand {
    func addErrorNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(errorNoti(noti:)), name: NSNotification.Name.errorNotification, object: nil)
    }
    @objc
    func errorNoti(noti: Notification) {
        if ErrorCenter.shared.message.isEmpty {
            completionHandler(nil)
        }else {
            completionHandler(error(msg: ErrorCenter.shared.message))
        }
    }
}

// MARK: - json Helper

private extension SourceEditorCommand {
    func error(msg: String) -> Error {
        return NSError(domain: domain, code: 300, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    /// 添加引入模块
    func importModel(lines: inout NSMutableArray) {
        var firstImportIndex: Int = 8
        if lines.count < 9 {
            firstImportIndex = 0
        }
        var aimIndex = firstImportIndex
        for (index, value) in lines.enumerated() {
            guard let value = value as? String else {
                return
            }
            if value.contains(keyImport) {
                if value.contains("Foundation") || value.contains("UIKit") {
                    aimIndex = index + 1
                } else {
                    aimIndex = index
                }
                break
            }
        }
        let needImport = filterModle(lines: &lines)
        for modle in needImport {
            lines.insert("\(keyImport) \(modle)\n", at: aimIndex)
        }
    }
    
    /// 过滤已添加的Modle
    func filterModle(lines: inout NSMutableArray) -> [String] {
        let waitImport = config.moduleArr
        let imported: [String] = lines.filter { ($0 as! String).contains(keyImport) } as! [String]
        let needImport = waitImport.filter { (modle) -> Bool in
            for line in imported {
                if line.contains(modle) {
                    return false
                }
            }
            return true
        }
        return needImport
    }
    
    /// 进行新增行整合
    func addLines(origin: inout NSMutableArray, new line: [String], invocation: XCSourceEditorCommandInvocation) {
        let buffer = invocation.buffer
        let sections = buffer.selections as! [XCSourceTextRange]
        var insertIndex = -1
        if let first = sections.first {
            insertIndex = first.start.line
        }
        
        if insertIndex > 0 {
            let insertLastLineValue = origin[insertIndex - 1]
            
            if origin.count > insertIndex {
                let currentLineValue = origin[insertIndex]
                if (currentLineValue as! String) != "\n" {
                    _ = origin[insertIndex]
                    insertIndex += 1
                }
            }
            if let value = insertLastLineValue as? String, value == "\n" {
            } else {
                origin.insert("\n", at: insertIndex)
                insertIndex += 1
            }
            let insertSet = NSIndexSet(indexesIn: NSRange(location: insertIndex, length: line.count))
            origin.insert(line, at: insertSet as IndexSet)
        } else {
            origin.addObjects(from: line)
        }
    }
    
    /// 生成对象
    func objectLine(commandIdentifier: CommandId, line: [String]) -> [String] {
        var keyword = keyStruct
        if commandIdentifier == classFromJSONCommand {
            keyword = keyClass
        } else if commandIdentifier == structFromJSONCommand {
            keyword = keyStruct
        }
        
        var objctLines: [String] = []
        let parent = config.parent
        var modelName = "<#Model#>"
        modelName = config.prefix + modelName + config.subffix
        if parent.isEmpty {
            objctLines.append("\(keyword) \(modelName) {")
        } else {
            objctLines.append("\(keyword) \(modelName): \(parent) {")
        }
        
        objctLines.append(contentsOf: line)
        if commandIdentifier == classFromJSONCommand, parent.contains("HandyJSON") {
            objctLines.append("")
            objctLines.append("\trequired init() { }")
        }
        objctLines.append("}")
        return objctLines
    }
}

// MARK: - Transform

extension SourceEditorCommand {
    /// 类型判断
    /// - Parameter value: 值
    func typeOf(value: Any) -> String {
        if value is NSNull {
            print("存在null")
            return "<#NSNull#>"
        } else if value is String {
            print("存在字符串:\(value)")
            return "String"
        } else if value is Int {
            // 需要先判断int
            print("存在Int:\(value)")
            return "Int"
        } else if value is Double {
            print("存在Doble:\(value)")
            return "Double"
        } else if value is [Any] {
            print("存在数组:\(value)")
            if let arr = value as? [Any], let first = arr.first {
                return "[\(typeOf(value: first))]"
            } else {
                return "unknow"
            }
            
        } else if value is [String: Any] {
            print("存在子类型：\(value)")
            return "<#SubModel#>"
        } else {
            print("存在未定义项")
            return "unknow"
        }
    }
    
    func linesFrom(paste: String) -> Result<[String], Error> {
        do {
            let object = try JSONSerialization.jsonObject(with: paste.data(using: .utf8)!, options: .mutableLeaves)
            guard let dic = object as? [String: Any] else {
                return Result.failure(error(msg: "json 对象转换为字典失败！"))
            }
            var lines: [String] = []
            for (label, value) in dic {
                lines.append("\(label): \(typeOf(value: value))")
            }
            if !config.isNotOptional {
                if config.isImplicitlyOptional {
                    lines = lines.map { "\tvar " + $0 + "!" }
                } else {
                    lines = lines.map { "\tvar " + $0 + "?" }
                }
            } else {
                 lines = lines.map { "\tvar " + $0 }
            }
            let aimLines = Array.init(lines.reversed())
            print("目标模板")
            print(aimLines)
            return Result.success(aimLines)
        } catch let e {
            print(e)
            return Result.failure(error(msg: "json序列化出错！"))
        }
    }
}
