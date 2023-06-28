//
//  RequestAPI.swift
//  MyLotto
//
//  Created by Luu Dinh Nam on 10/4/17.
//  Copyright © 2017 Luu Dinh Nam. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    /// Sử dụng v0 để làm đối tượng
    func autoLayoutVisualFormat(format:String,views:UIView...){
        var dic:Dictionary<String,Any> = [:]
        for (index,view) in views.enumerated()
        {
            dic["v\(index)"] = view
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: dic))
    }
}
struct APIResponse {
    let data: Data
    let statusCode: Int
}


func loadJson(link: String, method: HTTPMethod = .get, param: [String: Any] = [:], Authorization: String, completion: @escaping (Result<APIResponse>) -> Void) {
    var links = link
    if method == .get {
        if param.conertStringGet() != "" {
            links += "\(param.conertStringGet())"
        }
    }
    guard let url = URL(string: links) else {
        print("URL không hợp lệ")
        return
    }
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(Authorization, forHTTPHeaderField: "Authorization")
    if method == .post {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            print("Không thể chuyển đổi dữ liệu JSON")
            return
        }
        guard let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) else {
            print("Không thể chuyển đổi dữ liệu JSON thành chuỗi")
            return
        }
        print("params", jsonData)
        let body = jsonString.data(using: String.Encoding.utf8.rawValue)
        request.httpMethod = method.string
        request.httpBody = body
    }
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Request error: \(error.localizedDescription)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid HTTP response")
            return
        }
        let statusCode = httpResponse.statusCode
        if let data = data {
            let apiResponse = APIResponse(data: data, statusCode: statusCode)
            completion(.success(apiResponse))
        }
        
    }.resume()
    
}


extension Dictionary {
    func conertStringGet() -> String {
        var str:String = ""
        for (index,value) in self.enumerated()
        {
            if index == 0 {
                str += "\(value.value)"
            }else{
                str += "/\(value.value)"
            }
        }
        return str
    }
}
