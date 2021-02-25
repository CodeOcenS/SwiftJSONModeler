//
//  Panel.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2021/2/7.
//  Copyright © 2021 Sven. All rights reserved.
//
/// 文件导入和导出

import AppKit
/// 配置存在路径
let configPath =  (NSHomeDirectory() as NSString).appendingPathComponent("Config.plist")
struct PanelManager {
//    static let `default` = PanelManager()
//    private init() {}
    /// 导入文件
    func openPanelImportFile(completion: @escaping (_ url: URL?) -> Void) -> Void {
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
                let url = panel.url
                read(url: url)
                completion(url)
            } else {
                //取消
                completion(nil)
            }
        }
    }
    
    /// 导出文件
    func openPanelExportFile() -> Void {
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
                    saveFile(url: path)
                }
            } else {
                
            }
        }
    }
    
    private func read(url: URL?) {
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
       
        
        let configModel = ConfigModel()
        let propertyListEncoder = PropertyListEncoder()
        propertyListEncoder.outputFormat = .xml
        
        let plistData = try? propertyListEncoder.encode(configModel)
        let fileManager = FileManager.default
        let isSuccess = fileManager.createFile(atPath: configPath, contents: plistData, attributes: nil)  // 全覆盖写入
        if isSuccess {
            print("保存成功")
        } else {
            print("保存失败")
        }
    }
    
    /// 保存文件
    func saveFile( url: URL) -> Void {
        let fileManager = FileManager.default
        let contents = fileManager.contents(atPath: configPath)
        let isSuccess = fileManager.createFile(atPath: url.path, contents: contents, attributes: [FileAttributeKey.appendOnly : false, FileAttributeKey.extensionHidden: false])
        if isSuccess {
            print("保存成功")
        } else {
            print("保存失败")
        }
    }
}
