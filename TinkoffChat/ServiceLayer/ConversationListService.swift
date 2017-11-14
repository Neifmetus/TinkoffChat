//
//  ConversationListService.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 29.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

protocol IConversationServiceDelegate: class {
    var delegate: IConversationListModelDelegate? {get set}
    func updateConversationListWith(userID: String, userName: String?, online status: Bool)
}

class ConversationListService: ICommunicationManagerDelegate {
    var delegate: IConversationServiceDelegate?
    var conversationDelegate: IConversationModel?
    var communicationManager: CommunicationManager?
    
    init(delegate: IConversationServiceDelegate) {
        self.delegate = delegate
        self.communicationManager = CommunicationManager()
        self.communicationManager?.serviceDelegate = self
    }
    
    func connectWithOnlineUsers() {
        communicationManager?.communicateUsers()
    }
    
    func sendMessage(text: String, userID: String) {
        communicationManager?.sendMessage(text: text, userID: userID)
    }
    
    func didFound(userID: String, userName: String) {
        User.saveUser(with: userID, name: userName, isOnline: true)
    }
    
    func didLost(userID: String) {
        User.saveUser(with: userID, name: "", isOnline: false)
    }
    
    func didReceive(text: String, date: Date) {
        conversationDelegate?.receiveMessage(text: text, date: date)
    }
    
}
