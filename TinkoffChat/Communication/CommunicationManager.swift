//
//  MPCHandler.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 18.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol CommunicationDelegate : class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //masseges
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicationManager: NSObject, CommunicationDelegate {
    var foundedFriends: [Friend] = []
    var delegate: UIViewControllerDelegate?
    var conversationDelegate: ConverationDelegate?
    var manager: MPCHandler?
    var conversationListViewController: ConversationListViewController?
    
    override init() {
        super.init()
        self.manager = MPCHandler(delegate: self)
    }
    
    func sendMessage() {
        
    }
    
    func didFoundUser(userID: String, userName: String?) {
        if let friend = foundedFriends.first(where: {$0.userID == userID}) {
            friend.online = true
        } else {
            let newFriend = Friend(name: userName, userID: userID, messages: [], online: true, hasUnreadMessages: false)
            foundedFriends.append(newFriend)
        }
        delegate?.reloadFriends(foundedFriends)
    }
    
    func didLostUser(userID: String) {
        if let friend = foundedFriends.first(where: {$0.userID == userID}) {
            friend.online = false
        }
        
        delegate?.reloadFriends(foundedFriends)
    }
    
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        conversationDelegate?.receiveMessage(text: text)
    }
}

