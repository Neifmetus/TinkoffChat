//
//  ConversationListService.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 29.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

protocol IConversationListService: class {
    func didFound(userID: String, userName: String)
    func didLost(userID: String)
    func didReceive(text: String, date: Date)
}

class ConversationListService: IConversationListService {
    var delegate: IConversationListModel?
    var conversationDelegate: IConversationModel?
    var communicationManager: CommunicationManager?
    
    init(delegate: IConversationListModel) {
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
        delegate?.updateConversationListWith(userID: userID, userName: userName, online: true)
    }
    
    func didLost(userID: String) {
        delegate?.updateConversationListWith(userID: userID, userName: nil, online: false)
    }
    
    func didReceive(text: String, date: Date) {
        conversationDelegate?.receiveMessage(text: text, date: date)
    }
    
}
