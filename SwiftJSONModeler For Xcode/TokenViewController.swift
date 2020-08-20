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
    private func removeOneRowToken(_ index: Int) {
        if index < dataSource.count  {
            dataSource.remove(at: index)
            updateTokenView()
        } else {
            
        }
        
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
            stackView.removeArrangedSubview(tokenViews.last!)
            tokenViews.removeLast()
            
           // let deleteNumber = viewsCount - tokenCount
//            let willRemoveTokenView = tokenViews.dropFirst(deleteNumber)
//            willRemoveTokenView.forEach {  stackView.removeArrangedSubview($0) }
        }
        for (index, tokenView) in tokenViews.enumerated() {
            if index < dataSource.count {
                let value = dataSource[index]
                tokenView.titleTextField.stringValue = value.title
                tokenView.tokenTextField.stringValue = value.token
            }
            tokenView.buttonTag = index
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
             dataSource.append((title: value.titleTextField.stringValue, token: value.tokenTextField.stringValue))
        }
    }
    

    
    @IBAction func AddButtonTap(_ sender: NSButton) {
        
    }
}
