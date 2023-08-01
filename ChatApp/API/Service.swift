//
//  Service.swift
//  ChatApp
//
//  Created by Macbook on 27/07/23.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Service{
    static func fetchUsers(completion: @escaping ([User]) -> Void){
        var users = [User]()
        COLLECTION_USERS.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> Void){
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGE.document(currentUid).collection(user.uid).order(by: "timeStamp")
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added{
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchConversation(completion: @escaping ([Conversation]) -> Void){
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGE.document(uid).collection("recentMessages").order(by: "timeStamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                self.fetchUser(withUid: message.toID) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void){
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            print("inside fetch user")
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text": message, "fromID": currentUid, "toID" : user.uid, "timeStamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_MESSAGE.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGE.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGE.document(currentUid).collection("recentMessages").document(user.uid).setData(data)
            
            COLLECTION_MESSAGE.document(user.uid).collection("recentMessages").document(currentUid).setData(data)
        }
    }
}
