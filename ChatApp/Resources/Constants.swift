//
//  Constants.swift
//  ChatApp
//
//  Created by Macbook on 28/07/23.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

let COLLECTION_MESSAGE = Firestore.firestore().collection("messages")
let COLLECTION_USERS  = Firestore.firestore().collection("users")
