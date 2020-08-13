//
//  ErrorCenter.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let errorNotification = Notification.Name("errorNoti")
}

class ErrorCenter {
    static let shared: ErrorCenter = ErrorCenter()
    
    var message: String = "" {
        didSet {
            print(message)
            NotificationCenter.default.post(name: .errorNotification, object: nil)
        }
    }
    private init() {
        
    }
}
