//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by Macbook on 28/07/23.
//

import UIKit

struct MessageViewModel{
    
    private let message: Message
    
    var messageBackgroundColor: UIColor  {
        return message.isFromCurrentUser ? .systemMint : .systemCyan
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool{
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool{
        return message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool{
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else  { return nil }
        return URL(string: user.profileImageUrl)
    }
    
    
    init(message: Message) {
        self.message = message
    }
}
