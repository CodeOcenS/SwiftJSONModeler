//
//  SourceEditorCommand.swift
//  LExt
//
//  Created by Sven on 2020/1/21.
//  Copyright © 2020 Sven. All rights reserved.
//

import AppKit
import XcodeKit

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
            handleInvocation(invocation, json: pasteboardTest, completionHandler: completionHandler)
            //handleInvocation(invocation, handler: completionHandler)
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
    private func handleInvocation(_ invocation: XCSourceEditorCommandInvocation, json: String, completionHandler: @escaping (Error?) -> Void) {
        guard let transformObject = JSONHelper(paste: json).transform() else {
            completionHandler(nil)
            return
        }
        let yapiCreator = YApiCreator(invocation: invocation,
                                      yapiObject: transformObject)
        let models = yapiCreator.getModels()
        var lines = invocation.buffer.lines
        lines.addObjects(from: models)
        importModel(lines: &lines)
        completionHandler(nil)
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

}
