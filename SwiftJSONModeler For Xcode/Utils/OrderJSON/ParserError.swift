//
//  ParserError.swift
//  
//
//  Created by Sven on 2021/4/20.
//

import Foundation

struct ParserError: Error, CustomStringConvertible {
    let message: String
    
    init(msg: String) {
        self.message = msg
    }
    
    var description: String {
        return "ParserError: \(message)"
    }
}
