//
//  LoginViewModel.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 26/06/2023.
//

import UIKit

class LoginViewModel {
    
    var userName: Observable<String?> = Observable("")
    var passWord: Observable<String?> = Observable("")
    var isLogin: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable("")
    var viewController: UIViewController?
    var storyboard: UIStoryboard?
    private var loginRepository = LoginRepository()
    
    
    func login() {
        self.isLogin.value = true
        guard let userName = userName.value, let passWord = passWord.value else {
            // Handle missing userName or password
            return
        }
        self.loginRepository.loginUser(userName: userName, passWord: passWord) { result in
            switch result {
            case .success(let apiResponse):
                self.isLogin.value = false
                do{
                    if (200...299).contains(apiResponse.statusCode) {
                        let decoder = JSONDecoder()
                        let userData = try decoder.decode(UserData.self, from: apiResponse.data)
                        self.errorMessage.value = ""
                        UserDataStorage.saveUserData(userData: userData)
                        DispatchQueue.main.async { [self] in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
                            
                            guard let nextForm = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController else {
                                return
                                
                            }
                            nextForm.modalPresentationStyle = .fullScreen
                            viewController?.present(nextForm, animated: true, completion: nil)
                        }
                    } else {
                        let result = try JSONSerialization.jsonObject(with: apiResponse.data,options: JSONSerialization.ReadingOptions.mutableContainers)
                        if let result = result as? [String: Any], let errorMessage = result["errorMessage"] as? String {
                            self.errorMessage.value = errorMessage
                        }
                    }
                } catch{
                    
                }
            case .failure(let error):
                // Xử lý lỗi
                print("Error:", error)
            }
        }
    }
}

