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
    
    @IBOutlet weak var typeOptionalBtn0: NSButton!
    @IBOutlet weak var typeOptionalBtn1: NSButton!
    @IBOutlet weak var typeOptionalBtn2: NSButton!
    @IBOutlet weak var isShowOptionalBtn: NSButton!
    @IBOutlet weak var isArrayEmptyBtn: NSButton!
    @IBOutlet weak var isShowYApiMockBtn: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromUserDefault()
    }
    
    private func updateFromUserDefault() {
        confromTextField.stringValue = config.conform
        moduleTextField.stringValue = config.module
        prefixTextField.stringValue = config.prefix
        subffixTextField.stringValue = config.subffix
        updateOptionalType(config.optionalType)
        isShowOptionalBtn.state = config.isImplicitlyOptional ? .off : .on
        isArrayEmptyBtn.state = config.arrayIsDefaultNotEmpty ? .off : .on
        isShowYApiMockBtn.state = config.isShowYApiMock ? .on : .off
    }
    
    private func updateOptionalType(_ type: Config.OptionalType) {
        switch type {
        case .all:
            typeOptionalBtn0.state = .on
            typeOptionalBtn1.state = .off
            typeOptionalBtn2.state = .off
        case .some:
            typeOptionalBtn0.state = .off
            typeOptionalBtn1.state = .on
            typeOptionalBtn2.state = .off
        case .not:
            typeOptionalBtn0.state = .off
            typeOptionalBtn1.state = .off
            typeOptionalBtn2.state = .on
        }
    }
    
    @IBAction func saveButtonTap(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func typeOptionalBtnTap(_ sender: NSButton) {
        let baseTag = 10
        let tag = sender.tag - baseTag
        let type = Config.OptionalType(rawValue: tag) ?? Config.OptionalType.all
        updateOptionalType(type)
        config.optionalType = type
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
