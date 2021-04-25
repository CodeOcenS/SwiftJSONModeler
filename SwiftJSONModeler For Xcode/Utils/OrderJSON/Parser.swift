//
//  Parser.swift
//  json
//
//  Created by mac on 2021/4/14.
//

import Foundation

struct JsonParserError: Error {
    var msg: String
    init(msg: String) {
        self.msg = msg
    }
}

/// 分词 + AST
// [自己动手实现一个简单的JSON解析器](https://segmentfault.com/a/1190000010998941)

// 1. 词法分析：按照构词规则将 JSON 字符串解析成 Token 流
// 2. 语法分析：根据 JSON 文法检查上面 Token 序列所构词的 JSON 结构是否合法

enum JsonToken: Equatable {
    case objBegin // {
    case objEnd   // }
    case arrBegin // [
    case arrEnd   // ]
    case null    // null
    case number(String)   // 1
    case string(String)   // "a"
    case bool(String)     // true false
    case sepColon // :
    case sepComma // ,
    
    static func == (lhs: JsonToken, rhs: JsonToken) -> Bool {
        switch (lhs, rhs) {
        case let (.string(l), .string(r)): return l == r
        case let (.number(l), .number(r)): return l == r
        case let (.bool(l), .bool(r)): return l == r
        case (.null, .null): return true
        case (.objEnd, .objEnd): return true
        case (.objBegin, .objBegin): return true
        case (.arrBegin, .arrBegin): return true
        case (.arrEnd, .arrEnd): return true
        case (.sepComma, .sepComma): return true
        case (.sepColon, .sepComma): return true
        default: return false
        }
    }
    
}

/// 分词
struct JsonTokenizer {
    
    private var input: String
    
    private var currentIndex: String.Index
    
    init(string: String) {
        self.input = string
        self.currentIndex = string.startIndex
    }
    
    /// 当前字符
    private var current: Character? {
        guard currentIndex < input.endIndex else {return nil}
        return input[currentIndex]
    }
    
    /// 上一个字符
    private var previous: Character? {
        guard currentIndex > input.startIndex else {return nil}
        let index = input.index(before: currentIndex)
        return input[index]
    }
    
    /// 下一个字符
    private var next: Character? {
        guard currentIndex < input.endIndex else {return nil}
        let index = input.index(after: currentIndex)
        guard index < input.endIndex else {return nil}
        return input[index]
    }
    
    /// 移动下标
    private mutating func advance() {
        currentIndex = input.index(after: currentIndex)
    }
    
    private mutating func back() {
        currentIndex = input.index(before: currentIndex)
    }
    
    mutating func nextToken() throws -> JsonToken? {
        scanSpaces()
        guard let ch = current else {
            return nil
        }
        
//        print("nextToken::ch:\(ch)")
        
        switch ch {
        case "{":
            advance()
            return JsonToken.objBegin
        case "}":
            advance()
            return JsonToken.objEnd
        case "[":
            advance()
            return JsonToken.arrBegin
        case "]":
            advance()
            return JsonToken.arrEnd
        case ",":
            advance()
            return JsonToken.sepComma
        case ":":
            advance()
            return JsonToken.sepColon
        case "n":
            let _ = try scanMatch(string: "null")
            //advance() // Sven 解决遇到 null 下一个字符偏移问题
            return JsonToken.null
        case "t":
            let str = try scanMatch(string: "true")
            return JsonToken.bool(str)
        case "f":
            let str = try scanMatch(string: "false")
            return JsonToken.bool(str)
        case "\"":
            let str = try scanString()
            advance()
            return JsonToken.string(str)
        case _ where isNumber(c: ch):
            let str = try scanNumbers()
            return JsonToken.number(str)
        default:
              throw JsonParserError(msg: "无法解析的字符:\(ch) - \(currentIndex)")
        }
    }
    
    private mutating func peekNext() -> Character? {
        advance()
        return current
    }
    
    mutating func scanString() throws -> String {
        var ret:[Character] = []
        
        repeat {
            guard let ch = peekNext() else {
                throw JsonParserError(msg: "scanString 报错，\(currentIndex) 报错")
            }
            switch ch {
            case "\\": // 处理转义字符
                guard let cn = peekNext(), !isEscape(c: cn) else {
                    throw JsonParserError(msg: "无效的特殊类型的字符")
                }
                ret.append("\\")
                ret.append(cn)
                /// 处理 unicode 编码
                if cn == "u" {
                    try ret.append(contentsOf: scanUnicode())
                }
            case "\"": //  碰到另一个引号，则认为字符串解析结束
                return String(ret)
            case "\r", "\n": // 传入JSON 字符串不允许换行
                throw JsonParserError(msg: "无效的字符\(ch)")
            default:
                ret.append(ch)
            }
        } while (true)
    }
    
    mutating func scanUnicode() throws -> [Character] {
        var ret:[Character] = []
        for _ in 0..<4 {
            if let ch = peekNext(), isHex(c: ch) {
                ret.append(ch)
            } else {
                throw JsonParserError(msg: "unicode 字符不规范\(currentIndex)")
            }
        }
        return ret
    }
    
    mutating func scanNumbers() throws -> String {
        let ind = currentIndex
        while let c = current, isNumber(c: c) {
            advance()
        }
        if currentIndex != ind {
            return String(input[ind..<currentIndex])
        }
        throw JsonParserError(msg: "scanNumbers 出错:\(ind)")
    }
    
    /// 跳过空格
    mutating func scanSpaces() {
        var ch = current
        while ch != nil && ch == " " {
            ch = peekNext()
        }
    }
    
    mutating func scanMatch(string: String) throws -> String {
        return try scanMatch(characters: string.map { $0 })
    }
    
    mutating func scanMatch(characters: [Character]) throws -> String {
        let ind = currentIndex
        var isMatch = true
        for index in (0..<characters.count) {
            if characters[index] != current {
                isMatch = false
                break
            }
            advance()
        }
        if (isMatch) {
            return String(input[ind..<currentIndex])
        }
        throw JsonParserError(msg: "scanUntil 不满足 \(characters)")
    }
    
    func isEscape(c: Character) -> Bool {
        // \" \\ \u \r \n \b \t \f
        return ["\"", "\\", "u", "r", "n", "b", "t", "f"].contains(c)
    }
    
    /// 判断是否是数字字符
    func isNumber(c: Character) -> Bool {
        let chars:[Character: Bool] = ["-": true, "+": true, "e": true, "E": true, ".": true]
        if let b = chars[c], b {
            return true
        }
        
        if(c >= "0" && c <= "9") {
            return true
        }
        
        return false;
    }

    /// 判断是否为 16 进制字符
    func isHex(c: Character) -> Bool {
        return c >= "0" && c <= "9" || c >= "a" && c <= "f" || c >= "A" && c <= "F"
    }

}

// 语法解析
struct JsonParser {
    private var tokenizer: JsonTokenizer
    
    private init(text: String) {
        tokenizer = JsonTokenizer(string: text)
    }
    
    static func parse(text: String) throws -> JSON? {
        var parser = JsonParser(text: text)
        return try parser.parse()
    }
    
    
    private mutating func parseElement() throws -> JSON? {
        guard let nextToken = try tokenizer.nextToken() else {
            return nil
        }
        
        switch nextToken {
        case .arrBegin:
            return try JSON(parserArr())
        case .arrEnd:  // Sven: 解决空数组问题
            return nil
        case .objBegin:
            return try JSON(parserObj())
        case .bool(let b):
            return .bool(b == "true")
        case .null:
            return .null
        case .string(let str):
            return .string(str)
        case .number(let n):
            if n.contains("."), let v = Double(n) {
                return .double(v)
            } else if let v = Int(n) {
                return .int(v)
            } else {
                throw ParserError(msg: "number 转换失败")
            }
        default:
            throw ParserError(msg: "未知 element: \(nextToken)")
        }
    }
    
    private mutating func parserArr() throws -> [JSON] {
        var arr: [JSON] = []
        repeat {
            guard let ele = try parseElement() else {
                //throw ParserError(msg: "parserArr 解析失败")
                return arr
            }
            
            arr.append(ele)
            
            guard let next = try tokenizer.nextToken() else {
                throw ParserError(msg: "parserArr 解析失败")
            }
            
            if case JsonToken.arrEnd = next {
                break
            }
            
            if JsonToken.sepComma != next { // ","
                throw ParserError(msg: "parserArr 解析失败")
            }
            
        } while true

        return arr
    }
    
    private mutating func parserObj() throws -> [String: JSON] {
        var obj: [String: JSON] = [:]

        repeat {
            
            guard let next = try tokenizer.nextToken() else {
                throw ParserError(msg: "parserObj 错误, nextToken 不存在")
            }
            guard next != .objEnd else {  // Sven: 解决空数组问题
                break
            }
            guard case let .string(key) = next else {
                throw ParserError(msg: "parserObj 错误, key 不存在")
            }
            
            if obj.keys.contains(key) {
                throw ParserError(msg: "parserObj 错误, 已经存在key: \(key)")
            }
            
            guard let comma = try tokenizer.nextToken(), case JsonToken.sepColon = comma else {
                throw ParserError(msg: "parserObj 错误，：不存在")
            }
            
            guard let value = try parseElement() else {
                throw ParserError(msg: "parserObj 错误，值不存在")
            }
            
            obj[key] = value
            
            guard let nex = try tokenizer.nextToken() else {
                throw ParserError(msg: "parserObj 错误， 下一个值不存在")
            }
            
            if case JsonToken.objEnd = nex {
                break
            }
            
            if JsonToken.sepComma != nex {
                throw ParserError(msg: "parserObj 错误，, 不存在")
            }
        } while true

        return obj
    }
    
    private mutating func parse() throws  -> JSON? {
        guard let token = try tokenizer.nextToken() else {
            return nil
        }
        switch token {
        case .arrBegin:
            return try JSON(parserArr())
        case .objBegin:
            return try JSON(parserObj())
        default:
            return nil
        }
    }
    
}





