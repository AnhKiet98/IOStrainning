//
//  LoginViewController.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 26/06/2023.
//

import UIKit
class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    // Instantiate LoginViewModel and use lazy loading for initialization
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    // Override viewDidLoad method of UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewController = self  // Assign self to viewController property of viewModel
        setupBindings()  // Call setupBindings method to bind data
    }
    
    // Define method to setup data bindings
    func setupBindings() {
        // Add target-action methods for userName and passWord text field's editingChanged event
        userName.addTarget(self, action: #selector(userNameDidChange), for: .editingChanged)
        passWord.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        
        // Bind the userName property of viewModel to the text property of userName text field
        viewModel.userName.bind { [weak self] userName in
            self?.userName.text = userName
        }
        
        // Bind the passWord property of viewModel to the text property of passWord text field
        viewModel.passWord.bind { [weak self] password in
            self?.passWord.text = password
        }
        
        // Bind the errorMessage property of viewModel to the text property of errorMessage label
        viewModel.errorMessage.bind { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.errorMessage.text = errorMessage
            }
        }
    }
    
    // Define target-action method for userName text field's editingChanged event
    @objc func userNameDidChange() {
        viewModel.userName.value = userName.text ?? ""  // Update userName property of viewModel
    }
    
    // Define target-action method for passWord text field's editingChanged event
    @objc func passwordDidChange() {
        viewModel.passWord.value = passWord.text ?? ""  // Update passWord property of viewModel
    }
    
    // Define action method for Login button's touchUpInside event
    @IBAction func btnLogin(_ sender: Any) {
        viewModel.login()  // Call login method of viewModel
    }
}
