//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Macbook on 28/07/23.
//

import Foundation

struct ConversationViewModel {
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timeStamp: String{
        let date = conversation.message.timeStamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
