//
//  TokenViewController.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/20.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa

class TokenViewController: NSViewController {

    @IBOutlet weak var stackView: NSStackView!
    private let rowHeight: CGFloat = 60
    private var dataSource: [(title: String, token: String)] = []
    
    private var tokenViews: [TokenView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
    }
    
    private func setupView() {
        updateTokenView()
    }
    
    /// 删除一行token 数据
    private func remoçveOneRowToken(_ index: Int) {
        dataSource.remove(at: index)
        updateTokenView()
    }
    
    private func updateTokenView() {
        let tokenCount = dataSource.count + 1
        let viewsCount = tokenViews.count
        // 需要增加
        if tokenCount > viewsCount {
            let addNumber = tokenCount - viewsCount
            let views = [1...addNumber].map {
                (value) -> TokenView in
                let tokenView = TokenView()
                tokenView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
                stackView.addArrangedSubview(tokenView)
                tokenView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
                return tokenView
            }
            tokenViews.append(contentsOf: views)
        }
        // 需要删除
        if tokenCount < viewsCount {
            let deleteNumber = viewsCount - tokenCount
            tokenViews.removeLast(deleteNumber)
        }
        for (index, value) in dataSource.enumerated() {
            let tokenView = tokenViews[index]
            tokenView.titleTextField.stringValue = value.title
            tokenView.tokenTextField.stringValue = value.token
            tokenView.buttonTag = index
          // ??? 闭包没有回调
            tokenView.deleteClosure = {
                 index in
                print("删除第\(index+1)行")
                self.removeOneRowToken(index)
            }
           tokenView.addClosure  = {
                [weak self] index in
                self?.updateDataSource()
                self?.updateTokenView()
            }
        }
    }
    /// 保存一次值
    private func updateDataSource() {
         dataSource = []
        for (index, value) in tokenViews.enumerated() {
            guard index != tokenViews.count - 1 else {
                return
            }
            dataSource.append((title: value.titleTextField.stringValue, token: value.tokenTextField.stringValue))
        }
    }
    

    
    @IBAction func AddButtonTap(_ sender: NSButton) {
        
    }
}
