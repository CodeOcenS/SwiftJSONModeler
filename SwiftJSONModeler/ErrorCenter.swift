//
//  ErrorCenter.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/16.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation

class ErrorCenter {
    static let shared: ErrorCenter = ErrorCenter()
    
    var message: String = ""
    private init() {
        
    }
}
