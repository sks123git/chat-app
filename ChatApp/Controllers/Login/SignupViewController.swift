//
//  SignupViewController.swift
//  ChatApp
//
//  Created by Macbook on 23/07/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class SignupViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: - Properties
    
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo" ), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
   
    
    private lazy var fullnameContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: fullnameTextField)
    }()
    
    private lazy var usernameContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x"), textField: usernameTextField)
    }()
    
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"), textField: passwordTextField)
    }()
    
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    
    private let passwordTextField: CustomTextField = {
        let passwordText = CustomTextField(placeholder: "Password")
        passwordText.isSecureTextEntry = true
        return passwordText
    }()
    
    private let signupButton: UIButton = {
       let signupButton = UIButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.layer.cornerRadius = 5
        signupButton.titleLabel?.font =   UIFont.boldSystemFont(ofSize: 18)
        signupButton.backgroundColor = .systemPink
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.setHeight(height: 50)
        signupButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return signupButton
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        view.backgroundColor = .systemMint
    }
    
    //MARK: - Selectors
    @objc func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShowSignUp(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        guard let fullname = fullnameTextField.text?.lowercased() else {return}
        guard let profileImage = profileImage else {return}
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true, withText: "Logging in")

        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error{
                print("Failed to login with error \(error)")
                self.showLoader(false)
                return
            }
            
            self.showLoader(false)
            self.dismiss(animated: true)
        }
    }
    
    
    @objc func textDidChanged(){
        
    }
    
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    
    //MARK: - Helpers
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView,
                                                   usernameContainerView,
                                                   signupButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 32, paddingRight: 32)
    }
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension SignupViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage else {return}
        self.profileImage = selectedImage
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
