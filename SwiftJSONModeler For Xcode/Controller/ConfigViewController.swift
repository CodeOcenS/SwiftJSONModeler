//
//  ConfigViewController.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/1/22.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa



class ConfigViewController: NSViewController {
    
    private let config = Config()
    private var tokens: [Token] = []
    private var token: String = ""
    
    @IBOutlet weak var confromTextField: NSTextField!
   
    @IBOutlet weak var moduleTextField: NSTextField!
    @IBOutlet weak var prefixTextField: NSTextField!
    @IBOutlet weak var subffixTextField: NSTextField!
    @IBOutlet weak var isAllowOptionalBtn: NSButton!
    @IBOutlet weak var isShowOptionalBtn: NSButton!
    @IBOutlet weak var isArrayEmptyBtn: NSButton!
    @IBOutlet weak var isShowYApiMockBtn: NSButton!
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var tokenBox: NSComboBox!
    @IBOutlet weak var configTokenButton: NSButton!
    @IBOutlet weak var yapiHostTextField: NSTextField!
    @IBOutlet weak var remarkTextField: NSTextField!
    @IBOutlet weak var guideButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromUserDefault()
        NotificationCenter.default.addObserver(forName: .tokenSaved, object: nil, queue: nil) { [weak self] (noti) in
            self?.setupBox()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateFromUserDefault() {
        confromTextField.stringValue = config.conform
        moduleTextField.stringValue = config.module
        prefixTextField.stringValue = config.prefix
        subffixTextField.stringValue = config.subffix
        pathTextField.stringValue = config.yapiPath
        //yapiTokenTextField.stringValue = config.yapiToken
        yapiHostTextField.stringValue = config.yapiHost
        configTokenButton.attributedTitle = NSAttributedString(string: "配置Token", attributes: [NSAttributedString.Key.foregroundColor : NSColor.blue])
        setupBox()
        remarkTextField.stringValue = config.remark
        
        isAllowOptionalBtn.state = config.isNotOptional ? .off : .on
        isShowOptionalBtn.state = config.isImplicitlyOptional ? .off : .on
        isArrayEmptyBtn.state = config.arrayIsDefaultNotEmpty ? .off : .on
        isShowYApiMockBtn.state = config.isShowYApiMock ? .on : .off
    }
    
    private func setupBox() {
        tokenBox.removeAllItems()
        tokenBox.usesDataSource = false
        let historyToken = config.yapiToken
        tokens = Token.getTokenFormUserDefault() // token配置中的 token
        let tokensTitle = tokens.map { $0.title }
        tokenBox.addItems(withObjectValues: tokensTitle)
        
        if !historyToken.isEmpty {
            if tokens.isEmpty {
                tokenBox.stringValue = historyToken
                token = historyToken
            } else {
                let filter = tokens.filter { $0.token == historyToken }
                if filter.count > 0 {
                    tokenBox.selectItem(withObjectValue: filter.first!.title)
                    token = filter.first!.token
                } else {
                    tokenBox.stringValue = historyToken
                    token = historyToken
                }
            }
        }
    }
    
    private func tokenForSave() -> String {
        let boxValue = tokenBox.stringValue
        guard !boxValue.isEmpty else {
            return ""
        }
        // 判断是否为选中的
        let filter = tokens.filter { $0.title == boxValue }
        if filter.count > 0 {
            // 是选中的
            return filter.first!.token
        } else {
            // 填写的
            return  boxValue
        }
    }
    
    @IBAction func guideButtonTap(_ sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "https://gitee.com/Sven001/JSONSwfitModel")!)
    }
    
    @IBAction func saveButtonTap(_ sender: NSButton) {

//        config.conform = confromTextField.stringValue
//        config.module = moduleTextField.stringValue
//        config.prefix = prefixTextField.stringValue
//        config.subffix = subffixTextField.stringValue
//        config.yapiPath = pathTextField.stringValue
//        config.yapiToken = tokenForSave()
//        config.yapiHost = yapiHostTextField.stringValue
//        config.remark = remarkTextField.stringValue
//        view.window?.close()
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
