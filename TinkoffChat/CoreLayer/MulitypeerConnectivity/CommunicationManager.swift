//
//  MPCHandler.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 18.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ICommunicationManagerDelegate: class {
    func didFound(userID: String, userName: String)
    func didLost(userID: String)
    func didReceive(text: String, date: Date)
}

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
    var delegate: IConversationListModelDelegate?
    var serviceDelegate: ICommunicationManagerDelegate?
    var conversationDelegate: ConverationDelegate?
    var manager: MPCHandler?
    
    override init() {
        super.init()
        self.manager = MPCHandler(delegate: self)
    }
    
    func communicateUsers() {
        manager?.setupConnectivity()
    }
    
    func sendMessage(text: String, userID: String) {
        manager?.sendMessage(string: text, to: MCPeerID(displayName: userID)) {
            (success, error) in
            
            if let error = error {
                print(error)
            }
        }
    }
    
    func didFoundUser(userID: String, userName: String?) {
        serviceDelegate?.didFound(userID: userID, userName: userName ?? "")
    }
    
    func didLostUser(userID: String) {
        serviceDelegate?.didLost(userID: userID)
    }
    
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        serviceDelegate?.didReceive(text: text, date: Date())
    }
}

