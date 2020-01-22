//
//  ConfigViewController.swift
//  JSONSwiftModelApp
//
//  Created by Sven on 2020/1/22.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa



class ConfigViewController: NSViewController {
    @IBOutlet weak var confromTextField: NSTextField!
   
    @IBOutlet weak var moduleTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromUserDefault()
    }
    
    private func updateFromUserDefault() {
        let config = ConfigUserDefault.shared.getConfig()
        
        confromTextField.stringValue = config.confrom.isEmpty ? "" : config.confrom.joined(separator: ",")
        moduleTextField.stringValue = config.module.isEmpty ? "" : config.module.joined(separator: ",")
    }
    
    private func saveToUserDefault() {
        var confrom: [String] = []
        var module: [String] = []
        let confromStr = confromTextField.stringValue
        let moduleStr = moduleTextField.stringValue
        if !confromStr.isEmpty, !confromStr.contains("，") {
           confrom = confromStr.components(separatedBy: ",")
        }
        
        if !moduleStr.isEmpty,!moduleStr.contains("，") {
           module = moduleStr.components(separatedBy: ",")
        }
        
        ConfigUserDefault.shared.set(confrom: confrom, module: module)
    }
    
    
    @IBAction func saveButtonTap(_ sender: NSButton) {
        saveToUserDefault()
        // FIXME: - 怎么关闭窗口
    }
    
}
