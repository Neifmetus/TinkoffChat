//
//  DialogsHelper.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 08.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

enum MessageSource {
    case incoming
    case outgoing
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

struct Message {
    var text: String?
    var messageID: String?
    var date: Date?
    var source: MessageSource
}

extension ConversationListViewController {
    
    func createImaginaryFriends() {

    }

    
}
