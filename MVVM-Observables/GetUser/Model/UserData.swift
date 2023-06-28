//
//  UserData.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 27/06/2023.
//

import Foundation

struct UserData: Codable {
    let userId: Int
    let fullName: String
    let userName: String
    let avatar: String
    let email: String
    let role: String
    
    init(userId: Int, fullName: String, userName: String, avatar: String, email: String, role: String) {
        self.userId = userId
        self.fullName = fullName
        self.userName = userName
        self.avatar = avatar
        self.email = email
        self.role = role
    }
}
