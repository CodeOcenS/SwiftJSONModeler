//
//  TokenViewController.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/20.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa

extension Notification.Name {
    static let tokenSaved = Notification.Name(rawValue: "tokenSaved")
}

class TokenViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var tokenTextField: NSTextField!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var tokenContentView: NSView!
    private let tokenContentLayer = CALayer()
    private let rowHeight: CGFloat = 40
    private var dataSource: [YApiTokenModel] = []
    
    private var tokenViews: [TokenView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "配置 token"
        setupView()
        setupToken()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        tokenContentLayer.frame = tokenContentView.bounds
    }
    
    private func setupView() {
        tokenContentLayer.borderWidth = 1.0
        tokenContentLayer.borderColor = NSColor.lightGray.cgColor
        tokenContentLayer.cornerRadius = 10
        tokenContentView.layer = tokenContentLayer
    }
    private func setupToken() {
        dataSource = getToken()
        for (index, value) in dataSource.enumerated() {
            addTokenView(value, at: index)
        }
    }
    
    @IBAction func AddButtonTap(_ sender: NSButton) {
        addToken()
        NotificationCenter.default.post(name: .tokenSaved, object: nil)
    }
}

// MARK: - 数据处理
private extension TokenViewController {
    func addToken() {
        let title = titleTextField.stringValue
        let token = tokenTextField.stringValue
        guard !title.isEmpty && !token.isEmpty else {
            showAlert()
            return
        }
        let willAddToken = YApiTokenModel(name: title, token: token)
        dataSource.append(willAddToken)
        updateToken()
        addTokenView(willAddToken, at: dataSource.count - 1)
        titleTextField.stringValue = ""
        tokenTextField.stringValue = ""
    }
    func addTokenView(_ token: YApiTokenModel, at index: Int) {
        let tokenView = TokenView()
        tokenView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        stackView.addArrangedSubview(tokenView)
        tokenView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        tokenViews.append(tokenView)
        tokenView.deleteClosure = {
           [weak self] index in
            self?.deleteTokenAddView(at: index)
            NotificationCenter.default.post(name: .tokenSaved, object: nil)
        }
        tokenView.buttonTag = index
        tokenView.config(token: token)
    }
    func deleteTokenAddView(at index: Int) -> Void {
        dataSource.remove(at: index)
        updateToken()
        
        let willDeleteView = tokenViews[index]
        tokenViews.remove(at: index)
        stackView.removeArrangedSubview(willDeleteView)
        willDeleteView.removeFromSuperview()
        // 重置 tag 防止越界
        for (index, view) in tokenViews.enumerated() {
            view.buttonTag = index
        }

    }
    
    func showAlert() -> Void {
        let alert = NSAlert()
        alert.messageText = "错误"
        alert.informativeText = "项目名和 token不能为空"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { (modal) in
            
        }
        
    }
}
extension UserDefaults {
    enum Key: String {
        case tokens
    }
}
// MARK: - 数据持久化
private extension TokenViewController {
    func updateToken() -> Void {
        ConfigCenter.default.config.yapiTokenList = dataSource
        ConfigCenter.default.save()
    }
    
    func getToken() -> [YApiTokenModel] {
        return  ConfigCenter.default.config.yapiTokenList
    }
}
