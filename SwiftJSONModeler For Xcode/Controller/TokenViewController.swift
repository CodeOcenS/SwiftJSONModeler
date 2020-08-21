//
//  TokenViewController.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/20.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa

class TokenViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var tokenTextField: NSTextField!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var tokenContentView: NSView!
    private let tokenContentLayer = CALayer()
    private let rowHeight: CGFloat = 60
    private var dataSource: [Token] = []
    
    private var tokenViews: [TokenView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
    
    @IBAction func AddButtonTap(_ sender: NSButton) {
        addToken()
    }
}

// MARK: - 数据处理
private extension TokenViewController {
    func addToken() {
        let willAddToken = Token(title: titleTextField.stringValue, token: tokenTextField.stringValue)
        dataSource.append(willAddToken)
        titleTextField.stringValue = ""
        tokenTextField.stringValue = ""
        let tokenView = TokenView()
        tokenView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        stackView.addArrangedSubview(tokenView)
        tokenView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        tokenViews.append(tokenView)
        tokenView.deleteClosure = {
           [weak self] index in
            self?.deleteToken(at: index)
        }
        tokenView.config(token: willAddToken)
    }
    func deleteToken(at index: Int) -> Void {
        dataSource.remove(at: index)
        let willDeleteView = tokenViews[index]
        tokenViews.remove(at: index)
        stackView.removeArrangedSubview(willDeleteView)
        willDeleteView.removeFromSuperview()
    }
}

// MARK: - 数据持久化
private extension TokenViewController {
//    func (<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}
