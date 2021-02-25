//
//  OpenSavePanel.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/2/7.
//  Copyright © 2021 Sven. All rights reserved.
//
/// 文件导入和导出

import AppKit
import CleanJSON

struct OpenSavePanel {
    /// 导入文件
    func importFile(completion: @escaping (_ error: Error?) -> Void) -> Void {
        let panel = NSOpenPanel()
        panel.prompt = "确定"
        panel.message = "选择配置"
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowedFileTypes = ["plist"]
        panel.allowsMultipleSelection = false
        //panel.directoryURL =
        panel.beginSheetModal(for: NSApp.mainWindow ?? NSWindow() ) { (response) in
            if response == .OK {
                if let url = panel.url {
                    let isSuccess = read(url: url)
                    let error = NSError(domain: "swiftjsonmodeler.error", code: 5000, userInfo: [NSLocalizedDescriptionKey: "导入保存失败"])
                    completion(isSuccess ? nil : error )
                } else {
                   let error = NSError(domain: "swiftjsonmodeler.error", code: 5000, userInfo: [NSLocalizedDescriptionKey: "导入文件 url不存在"])
                    completion(error)
                }
                
            } else {
                //取消
                completion(NSError(domain: "swiftjsonmodeler.error", code: 5000, userInfo: [NSLocalizedDescriptionKey: "取消选择"]))
            }
        }
    }
    
    /// 导出文件
    func exportFile(completion: @escaping (_ error: Error?) -> Void) -> Void {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "Config.plist"
        savePanel.message = "请选择路径保存配置"
        savePanel.allowedFileTypes = ["plist"]
        savePanel.isExtensionHidden = false
        savePanel.canCreateDirectories = true
        //savePanel.directoryURL =
        savePanel.beginSheetModal(for: NSApp.mainWindow ?? NSWindow()) { (response) in
            if response == .OK {
                if let path = savePanel.url {
                    let isSuccess = saveFile(url: path)
                    let error = NSError(domain: "swiftjsonmodeler.error", code: 5000, userInfo: [NSLocalizedDescriptionKey: "导入保存失败"])
                    completion(isSuccess ? nil : error )
                } else {
                    completion(NSError(domain: "swiftjsonmodeler.error", code: 5000, userInfo: [NSLocalizedDescriptionKey: "导入文件 url不存在"]))
                }
            } else {
                completion(NSError(domain: "swiftjsonmodeler.error", code: 5000, userInfo: [NSLocalizedDescriptionKey: "取消选择"]))
            }
        }
    }
    /// 导入保存
    private func read(url: URL) -> Bool {
        let configCenter = ConfigCenter.default
        guard  let dic = NSDictionary(contentsOfFile:url.path), JSONSerialization.isValidJSONObject(dic) else {
            return false
        }
        guard let dicData = try? JSONSerialization.data(withJSONObject: dic, options: .fragmentsAllowed) else {
            return false
        }
        
        let decoder = CleanJSONDecoder()
        guard let model = try? decoder.decode(ConfigModel.self, from: dicData) else {
            return false
        }
        configCenter.config = model
        return configCenter.save()
    }
    
    /// 导出保存文件
    func saveFile( url: URL) -> Bool {
        let fileManager = FileManager.default
        let contents = fileManager.contents(atPath: configPath)
        let isSuccess = fileManager.createFile(atPath: url.path, contents: contents, attributes: [FileAttributeKey.appendOnly : false, FileAttributeKey.extensionHidden: false])
        if isSuccess {
            print("保存成功")
        } else {
            print("保存失败")
        }
        return isSuccess
    }
}
