//
//  LoginViewModel.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 26/06/2023.
//

// Import UIKit framework for UI related classes and functions
import UIKit

// Define LoginViewModel class
class LoginViewModel {
    
    // Create observable userName with initial value as empty string
    var userName: Observable<String?> = Observable("")
    // Create observable passWord with initial value as empty string
    var passWord: Observable<String?> = Observable("")
    // Create observable isLogin with initial value as false
    var isLogin: Observable<Bool> = Observable(false)
    // Create observable errorMessage with initial value as empty string
    var errorMessage: Observable<String?> = Observable("")
    // Declare optional viewController
    var viewController: UIViewController?
    
    // Define login function
    func login() {
        // Unwrap userName and passWord values
        guard let userName = userName.value, let passWord = passWord.value else {
            // Update errorMessage if either userName or passWord is nil
            self.errorMessage.value = "Please enter both username and password."
            // Exit function
            return
        }

        // Check if userName is empty and shorter than 4 characters
        if userName.isEmpty {
            self.errorMessage.value = "Username cannot be empty."
            return
        } else if userName.count < 4 {
            self.errorMessage.value = "Username must be at least 4 characters long."
            return
        }

        // Check if passWord is empty and shorter than 4 characters
        if passWord.isEmpty {
            self.errorMessage.value = "Password cannot be empty."
            return
        } else if passWord.count < 4 {
            self.errorMessage.value = "Password must be at least 4 characters long."
            return
        }
        
        // Clear errorMessage
        self.errorMessage.value = ""
        // Perform the following block after a delay of 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            // Unwrap self to avoid retain cycle
            guard let self = self else { return }
            // Check if userName and passWord are both "admin"
            if userName == "admin" && passWord == "admin" {
                // Create success alert
                let alertController = UIAlertController(title: "Success", message: "Login successful", preferredStyle: .alert)
                // Add "OK" button to alert
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                // Present the success alert
                self.viewController?.present(alertController, animated: true, completion: nil)
            } else {
                // Create fail alert
                let alertController = UIAlertController(title: "Fail", message: "Invalid username or password", preferredStyle: .alert)
                // Add "OK" button to alert
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                // Present the fail alert
                self.viewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


