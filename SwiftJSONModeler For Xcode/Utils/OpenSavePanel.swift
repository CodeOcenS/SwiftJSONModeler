//
//  OpenSavePanel.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/2/7.
//  Copyright © 2021 Sven. All rights reserved.
//
/// 文件导入和导出

import AppKit

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
//        guard let url = url else {
//            return
//        }
//        let plistFile = NSDictionary.init(contentsOf: url)
//        print(plistFile)
//        let data = try? Data(contentsOf: url) // 可能 datameiyou
//        let decoder = PropertyListDecoder()
//        do {
//            let config = try decoder.decode(ConfigModel.self, from: data!)
//        } catch let error {
//            print(error)
//        }
       
        
//        let configModel = ConfigModel()
//        let propertyListEncoder = PropertyListEncoder()
//        propertyListEncoder.outputFormat = .xml
//
//        let plistData = try? propertyListEncoder.encode(configModel)
    
        let fileManager = FileManager.default
        let configData = fileManager.contents(atPath: url.path)
        let isSuccess = fileManager.createFile(atPath: configPath, contents: configData, attributes: nil)  // 全覆盖写入
        if isSuccess {
            print("保存成功:\(configPath)")
        } else {
            print("保存失败")
        }
        return isSuccess
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
