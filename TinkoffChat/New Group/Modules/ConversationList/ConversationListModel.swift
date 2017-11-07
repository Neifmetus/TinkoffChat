//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 28.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

protocol IConversationListModelDelegate: class {
    func reloadFriends(_ friends: [Friend])
}

class ConversationListModel: IConversationServiceDelegate {
    var foundedFriends: [Friend] = []
    var service: ConversationListService?
    var delegate: IConversationListModelDelegate?
    
    init() {
        self.service = ConversationListService(delegate: self)
    }
    
    func findOnlineFriends() {
        service?.connectWithOnlineUsers()
    }
    
    func updateConversationListWith(userID: String, userName: String?, online status: Bool) {
        if let friend = foundedFriends.first(where: {$0.userID == userID}) {
            friend.online = status
        } else {
            let newFriend = Friend(name: userName, userID: userID, messages: [], online: true, hasUnreadMessages: false)
            foundedFriends.append(newFriend)
        }
        delegate?.reloadFriends(foundedFriends)
    }
}

class Friend {
    var name: String?
    var userID: String
    var messages: [Message]
    var online: Bool
    var hasUnreadMessages: Bool
    
    init(name: String?, userID: String, messages: [Message], online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.userID = userID
        self.messages = messages
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
}
