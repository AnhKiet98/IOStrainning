//
//  LoginRepository.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 26/06/2023.
//

import Foundation
enum Result<T> {
    case success(T)
    case failure(Error)
}
class LoginRepository {
    enum Constant {
        static let URLString = "https://api.eventspace.club/api/User/login"
    }
    
    func loginUser(userName: String, passWord: String, completion: @escaping (Result<APIResponse>) -> Void) {
        let method: HTTPMethod = .post
        let params: [String: Any] = [
            "userName": userName,
            "passWord": passWord
        ]
        //                    let reult = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers)
        //                    print("reult ",reult)
        
        let authorization = "" // Replace with your actual authorization inf1ormation
        
        loadJson(link: Constant.URLString, method: method, param: params, Authorization: authorization) { result in
            switch result {
            case .success(let apiResponse):
                completion(.success(apiResponse)) // Pass the successful data result to the completion
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
}


