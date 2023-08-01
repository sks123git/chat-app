//
//  CustomTextField.swift
//  ChatApp
//
//  Created by Macbook on 26/07/23.
//

import UIKit

class CustomTextField: UITextField{
    
    init(placeholder: String){
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
