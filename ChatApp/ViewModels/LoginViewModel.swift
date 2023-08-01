//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Macbook on 26/07/23.
//

import Foundation

struct LoginViewModel{
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
