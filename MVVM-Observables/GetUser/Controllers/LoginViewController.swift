//
//  LoginViewController.swift
//  MVVM-Observables
//
//  Created by PHAN ANH KIET on 26/06/2023.
//

import UIKit
class LoginViewController : UIViewController {
    
    @IBOutlet weak var userName: IconTextField!
    @IBOutlet weak var passWord: IconTextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.storyboard = storyboard
        viewModel.viewController = self
        setupBindings()
    }
    
    func setupBindings() {
        userName.addTarget(self, action: #selector(userNameDidChange), for: .editingChanged)
        passWord.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        
        viewModel.userName.bind { [weak self] userName in
            self?.userName.text = userName
        }
        
        viewModel.passWord.bind { [weak self] password in
            self?.passWord.text = password
        }
        
        viewModel.errorMessage.bind { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.errorMessage.text = errorMessage
            }
        }
        self.viewModel.isLogin.bind { isLogin in
            DispatchQueue.main.async(execute: { () -> Void in
                if isLogin {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    @objc func userNameDidChange() {
        viewModel.userName.value = userName.text ?? ""
    }
    
    @objc func passwordDidChange() {
        viewModel.passWord.value = passWord.text ?? ""
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        viewModel.login()
    }
}
