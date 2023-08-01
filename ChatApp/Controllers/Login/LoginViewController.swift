//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Macbook on 23/07/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {

    //MARK: - Properties
  
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bubble.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
   
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"), textField: passwordTextField)
    }()
    
    
    private let loginButton: UIButton = {
       let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.titleLabel?.font =   UIFont.boldSystemFont(ofSize: 18)
        loginButton.backgroundColor = .systemGray
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setHeight(height: 50)
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return loginButton
    }()
    
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    
    private let passwordTextField: CustomTextField = {
        let passwordText = CustomTextField(placeholder: "Password")
        passwordText.isSecureTextEntry = true
        return passwordText
    }()
    
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Signup", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        showLoader(true, withText: "Logging in")
    
        AuthService.shared.logUserIn(withEmail: email, password: password) {
            result, error in
            
            if let error = error{
                print("Failed to login with error")
                self.showLoader(false)
                return
            }
            
            self.showLoader(false)
            self.dismiss(animated: true)
        }
    }
    
    @objc func handleShowSignUp(){
            let vc = SignupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    //MARK: - Helpers
    
    func checkFormStatus(){
        if viewModel.formIsValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemRed
        }
        else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = .systemGray
        }
    }
    
    func configureUI(){
        navigationController?.navigationBar.isHidden  = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .systemCyan
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 32, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
