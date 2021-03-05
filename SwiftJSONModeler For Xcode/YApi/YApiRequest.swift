//
//  YApiRequest.swift
//  SwiftJSONModeler
//
//  Created by Sven on 2020/3/28.
//  Copyright © 2020 Sven. All rights reserved.
//

import Foundation

private let path = "/api/interface/get"

extension String {
    fileprivate func isPurnInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var value: Int = 0
        return scan.scanInt(&value) && scan.isAtEnd
    }
}

class YApiRequest {
    private static let errorCenter = ErrorCenter.shared
    private static let config = ConfigCenter.default.config
    private static func isAvailable(id: String) -> Bool {
        guard !id.isEmpty else {
            errorCenter.message = "YApi接口id不能为空"
            return false
        }
        guard id.isPurnInt() else {
            errorCenter.message = "YApi接口id格式异常"
            return false
        }
        guard !config.yapiToken.isEmpty else {
            errorCenter.message = "YApi项目token为空，请前往设置填写YApi项目token"
            return false
        }
        guard !config.yapiHost.isEmpty else {
            errorCenter.message = "YApi项目host为空，请前往设置填写YApi项目host"
            return false
        }
        return true
    }
    static func data(id: String,  comple: @escaping (String?) -> Void){
        let token = config.yapiToken
        let host = config.yapiHost
        guard isAvailable(id: id) else {
            comple(nil)
            return
        }
        data(id: id, token: token, host: host, comple: comple)
    }
    
    static func data(id: String, token: String, host: String, comple: @escaping (String?) -> Void){
        let url = host + path + "?token=\(token)&id=\(id)"
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                errorCenter.message = "获取YApi接口数据失败"
                comple(nil)
            }else {
                
                comple(handleData(data!))
            }
        }
        task.resume()
    }
    
    private static func handleData(_ data: Data) -> String?{
        let dataStr = String(data: data, encoding: .utf8)
        print("____dataStr")
        print(dataStr)
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            errorCenter.message = "获取数据 json 解析异常"
            return nil
        }
        guard  let code = json["errcode"] as? Int,  code == 0, let dataDic = json["data"] as? [String: Any], let resBody = dataDic["res_body"] as? String else   {
            var error = "获取接口数据异常"
            if let message = json["errmsg"] as? String {
                error = message
            }
            errorCenter.message = error
            return nil
        }
        let raw = resBody.replacingOccurrences(of: #"\""#, with: "\"")
        print("_____RAW\(raw)")
        return raw
    }
}
