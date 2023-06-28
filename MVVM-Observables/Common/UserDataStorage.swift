//
//  UserDataStorage.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 27/06/2023.
//

import Foundation

struct UserDataStorage {
    static let userDefaultsKey = "UserDataKey"
    
    static func saveUserData(userData: UserData) {
        do {
            let encoder = JSONEncoder()
            let userDataData = try encoder.encode(userData)
            
            UserDefaults.standard.set(userDataData, forKey: userDefaultsKey)
        } catch {
            print("Error encoding UserData: \(error)")
        }
    }
    
    static func getUserData() -> UserData? {
        if let userDataData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: userDataData)
                return userData
            } catch {
                print("Error decoding UserData: \(error)")
            }
        }
        
        return nil
    }
}

