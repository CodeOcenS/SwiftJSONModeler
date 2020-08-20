//
//  ConfigViewController.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/1/22.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa



class ConfigViewController: NSViewController {
    
    let config = Config()
    
    @IBOutlet weak var confromTextField: NSTextField!
   
    @IBOutlet weak var moduleTextField: NSTextField!
    @IBOutlet weak var prefixTextField: NSTextField!
    @IBOutlet weak var subffixTextField: NSTextField!
    @IBOutlet weak var isAllowOptionalBtn: NSButton!
    @IBOutlet weak var isShowOptionalBtn: NSButton!
    @IBOutlet weak var isArrayEmptyBtn: NSButton!
    @IBOutlet weak var isShowYApiMockBtn: NSButton!
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var yapiTokenTextField: NSTextField!
    @IBOutlet weak var yapiHostTextField: NSTextField!
    @IBOutlet weak var remarkTextField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromUserDefault()
        
    }
    
    
    
    private func updateFromUserDefault() {
        confromTextField.stringValue = config.conform
        moduleTextField.stringValue = config.module
        prefixTextField.stringValue = config.prefix
        subffixTextField.stringValue = config.subffix
        pathTextField.stringValue = config.yapiPath
        yapiTokenTextField.stringValue = config.yapiToken
        yapiHostTextField.stringValue = config.yapiHost
        
        remarkTextField.stringValue = config.remark
        
        isAllowOptionalBtn.state = config.isNotOptional ? .off : .on
        isShowOptionalBtn.state = config.isImplicitlyOptional ? .off : .on
        isArrayEmptyBtn.state = config.arrayIsDefaultNotEmpty ? .off : .on
        isShowYApiMockBtn.state = config.isShowYApiMock ? .on : .off
    }
    
    
    @IBAction func saveButtonTap(_ sender: NSButton) {
        config.conform = confromTextField.stringValue
        config.module = moduleTextField.stringValue
        config.prefix = prefixTextField.stringValue
        config.subffix = subffixTextField.stringValue
        config.yapiPath = pathTextField.stringValue
        config.yapiToken = yapiTokenTextField.stringValue
        config.yapiHost = yapiHostTextField.stringValue
        config.remark = remarkTextField.stringValue
        view.window?.close()
    }
    
    @IBAction func typeOptionalBtnTap(_ sender: NSButton) {
        config.isNotOptional = !(sender.state == .on)
    }
    /// 是否为显示可选
    @IBAction func isShowOptional(_ sender: NSButton) {
        config.isImplicitlyOptional = !(sender.state == .on)
    }
    @IBAction func isEmptyArrayBtnTap(_ sender: NSButton) {
        config.arrayIsDefaultNotEmpty = !(sender.state == .on)
    }
    @IBAction func isShowYApiMockBtnTap(_ sender: NSButton) {
        config.isShowYApiMock = sender.state == .on
    }
    
    
    
}
