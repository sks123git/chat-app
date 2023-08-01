//
//  ProfileHeader.swift
//  ChatApp
//
//  Created by Macbook on 28/07/23.
//

import UIKit

class ProfileHeader: UIView {
    
    //MARK: - Properties
    
    private let dismissButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImage: UIImageView  = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
     }()
    
    private let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    //MARK: - LifeCycles
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func handleDismissal(){
        
        
    }
    //MARK: - API
    
    //MARK: - Helpers
    func configureUI(){
        configureGradient()
        profileImage.setDimensions(height: 200, width: 200)
        profileImage.layer.cornerRadius = 200/2
        
        addSubview(profileImage)
        profileImage.centerX(inView: self)
        profileImage.anchor(top: topAnchor,paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImage.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor,paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
    func configureGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemCyan.cgColor, UIColor.systemMint.cgColor]
        gradient.locations = [0,1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
}
