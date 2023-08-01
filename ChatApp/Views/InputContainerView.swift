//
//  InputContainerView.swift
//  ChatApp
//
//  Created by Macbook on 26/07/23.
//

import UIKit

class InputContainerView: UIView{
    
    init(image: UIImage?,textField: UITextField){
        super.init(frame: .zero)
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.87
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor,paddingLeft: 8)
        iv.setDimensions(height: 20, width: 24)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor,bottom: bottomAnchor,right: rightAnchor, paddingLeft: 5, paddingBottom: -8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.80)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
