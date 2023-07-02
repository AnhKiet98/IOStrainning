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
    var isLogin: Observable<Bool?> = Observable(nil)
    // Create observable errorMessage with initial value as empty string
    var errorMessage: Observable<String?> = Observable("")
    
    // Define login function
    func login() {
        
        let validationError = validateInput(userName: userName.value, passWord: passWord.value)
        
        if let error = validationError {
            errorMessage.value = error.errorMessage
            return
        }
        // Clear errorMessage
        self.errorMessage.value = ""
        // Perform the following block after a delay of 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            // Unwrap self to avoid retain cycle
            guard let self = self else { return }
            // Check if userName and passWord are both "admin"
            if let userName = userName.value, let passWord = passWord.value {
                if userName == "admin" && passWord == "admin" {
                    self.isLogin.value = true
                }else {
                    // Handle the case when either `userName` or `passWord` is nil
                    self.isLogin.value = false
                }
            }
        }
    }
    // Function: validateInput(userName:passWord:)
    // This function validates the given username and password.
    // - Parameter userName: The userName to be validated. It should be a non-empty string with at least 4 characters.
    // - Parameter passWord: The passWord to be validated. It should be a non-empty string with at least 4 characters.
    // - Returns: If any of the username or password is invalid, it returns a `ValidationError` instance representing the first encountered error.
    //            If both username and password are valid, it returns nil.
    func validateInput(userName: String?, passWord: String?) -> ValidationError? {
        // Check if both userName and passWord are nil
        guard let unwrappedUserName = userName, let unwrappedPassword = passWord else {
            // Create a ValidationError instance with errorType .userNameNil and corresponding errorMessage
            return ValidationError(errorType: .userNameNil, errorMessage: ErrorType.userNameNil.errorMessage)
        }
        
        // Check if userName is empty
        if unwrappedUserName.isEmpty {
            // Create a ValidationError instance with errorType .userNameEmpty and corresponding errorMessage
            return ValidationError(errorType: .userNameEmpty, errorMessage: ErrorType.userNameEmpty.errorMessage)
        }
        // Check if userName has less than 4 characters
        else if unwrappedUserName.count < 4 {
            // Create a ValidationError instance with errorType .userNameTooShort and corresponding errorMessage
            return ValidationError(errorType: .userNameTooShort, errorMessage: ErrorType.userNameTooShort.errorMessage)
        }
        
        // Check if passWord is empty
        if unwrappedPassword.isEmpty {
            // Create a ValidationError instance with errorType .passWordEmpty and corresponding errorMessage
            return ValidationError(errorType: .passWordEmpty, errorMessage: ErrorType.passWordEmpty.errorMessage)
        }
        // Check if passWord has less than 4 characters
        else if unwrappedPassword.count < 4 {
            // Create a ValidationError instance with errorType .passWordTooShort and corresponding errorMessage
            return ValidationError(errorType: .passWordTooShort, errorMessage: ErrorType.passWordTooShort.errorMessage)
        }
        
        // If all checks pass, return nil to indicate no validation error
        return nil
    }
    
}

// Enum for holding different types of validation errors
enum ErrorType {
    case userNameEmpty
    case passWordEmpty
    case userNameTooShort
    case passWordTooShort
    case userNameNil
    case passWordNil
    case incorrectCredentials
    
    // Computed property that returns the corresponding error message for each error type
    var errorMessage: String {
        switch self {
        case .userNameEmpty:
            return "Please enter userName"
        case .passWordEmpty:
            return "Please enter passWord"
        case .userNameTooShort:
            return "UserName must be at least 4 characters"
        case .passWordTooShort:
            return "PassWord must be at least 4 characters"
        case .userNameNil:
            return "User name can't be nil"
        case .passWordNil:
            return "PassWord can't be nil"
        case .incorrectCredentials:
            return "Incorrect userName or passWord!"
        }
    }
}

// Struct for representing a validation error with an error type and message
struct ValidationError: Error {
    var errorType: ErrorType
    var errorMessage: String
    
    init(errorType: ErrorType, errorMessage: String) {
        self.errorType = errorType
        self.errorMessage = errorMessage
    }
}
