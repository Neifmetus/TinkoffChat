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
        let friendsNames = ["Tracer", "Diva", "McCree", "Mercy", "Soldier 76",
                            "Reaper", "Zarya", "Sombra", "Pharra", "Ana",
                            "Mei", "Bastion", "Genzi", "Hanzo", "Junkrat",
                            "Symmetra", "Reinhardt", "Winston", "Roadhog", "Zenyatta"]
        
        for index in 0...9 {
            let hasUnreadMessages = arc4random_uniform(2) == 0 ? true : false
            let online = index < 5 ? true : false
            let messages = createMessages()
            let conversationMessage = (index == 4 || index == 9) ? [] : messages.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
            let friend = Friend(name: friendsNames[index],
                                userID: "",
                                messages: conversationMessage,
                                online: online,
                                hasUnreadMessages: hasUnreadMessages)
            imaginaryFriends.append(friend)
        }
    }
    
    func createMessages() -> [Message] {
        let messages = [
            Message(text: "A", messageID: nil, date: Date.randomDate(daysBack: 1), source: .incoming),
                Message(text: String.randomWith(length: 30), messageID: nil, date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 300), messageID: nil, date: randomDate(), source: .incoming),
                Message(text: "B", messageID: nil, date: randomDate(), source: .outgoing),
                Message(text:String.randomWith(length: 30), messageID: nil, date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 100), messageID: nil, date: randomDate(), source: .outgoing)
        ]
        
        //let friend = Friend(name: "Tracer", messages: messages, online: true)
        return messages
    }
    
    func randomDate() -> Date {
        // TODO: need to configure
        return Date()
    }
    
}
