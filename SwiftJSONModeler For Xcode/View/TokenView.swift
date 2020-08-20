//
//  TokenView.swift
//  SwiftJSONModeler For Xcode
//
//  Created by Sven on 2020/8/20.
//  Copyright © 2020 Sven. All rights reserved.
//

import Cocoa

class TokenView: NSView {
    
    var buttonTag: Int {
        set {
            deleteButton.tag = newValue
        } get {
           return deleteButton.tag
        }
    }
    
    var deleteClosure: (_ index: Int) -> Void = { _ in }
    var addClosure: (_ index: Int) -> Void = { _ in }

    @IBOutlet private var contentView: NSView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var tokenTextField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet  private weak var deleteButton: NSButton!
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func layout() {
        super.layout()
        contentView.frame = bounds
    }
    
    private func commonInit() {
        NSNib(nibNamed: "TokenView", bundle: nil)!.instantiate(withOwner: self, topLevelObjects: nil)
        addSubview(contentView)
        contentView.layer?.backgroundColor = NSColor.orange.cgColor
        contentView.frame = bounds
        
        addButton.attributedTitle = NSAttributedString(string: "添加", attributes: [NSAttributedString.Key.foregroundColor : NSColor.blue])
        deleteButton.attributedTitle = NSAttributedString(string: "删除", attributes: [NSAttributedString.Key.foregroundColor : NSColor.red])
    }
    @IBAction func deleteButtonTap(_ sender: NSButton) {
        deleteClosure(sender.tag)
    }
    
    @IBAction func addButtonTap(_ sender: NSButton) {
        addClosure(sender.tag)
    }
}
