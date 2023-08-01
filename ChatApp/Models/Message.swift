//
//  Message.swift
//  ChatApp
//
//  Created by Macbook on 27/07/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct Message{
    let text: String
    let toID: String
    let fromID: String
    var timeStamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]){
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())

        self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
    }
}

struct Conversation{
    let user: User
    let message: Message
}
