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
    @IBOutlet weak var tokenContentView: NSView!
    private let tokenContentLayer = CALayer()
    private let rowHeight: CGFloat = 60
    private var dataSource: [(title: String, token: String)] = []
    
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
    
        let tokenView = TokenView()
        tokenView.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
        stackView.addArrangedSubview(tokenView)
        tokenView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
        stackView.layer?.borderColor = NSColor.gray.cgColor
        stackView.layer?.borderWidth = 1.0
    }
    
  
    
    @IBAction func AddButtonTap(_ sender: NSButton) {
        
    }
}
