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
struct Friend {
    var name: String?
    var messages: [Message]?
    var online: Bool
    var hasUnreadMessages: Bool
}

struct Message {
    var text: String?
    var date: Date?
    var source: MessageSource
}

extension ConversationListViewController {
    
    func createImaginaryFriends() {
        let friendsNames = ["Tracer", "Diva", "McCree", "Mercy", "Soldier 76",
                            "Reaper", "Zarya", "Sombra", "Pharra", "Ana",
                            "Mei", "Bastion", "Genzi", "Hanzo", "Junkrat",
                            "Symmetra", "Reinhardt", "Winston", "Roadhog", "Zenyatta"]
        
        let messages = createMessages()
        for index in 0...9 {
            let hasUnreadMessages = index >= 2 ? true : false
            let friend = Friend(name: friendsNames[index], messages: messages[index]?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending}), online: true, hasUnreadMessages: hasUnreadMessages)
            imaginaryFriends.append(friend)
        }
    }
    
    func createMessages() -> [[Message]?] {
        let messages = [
            [
                Message(text: "A", date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 300), date: randomDate(), source: .incoming),
                Message(text: "B", date: randomDate(), source: .outgoing),
                Message(text:String.randomWith(length: 30), date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .outgoing)
            ],
            [
                Message(text: "C", date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .incoming),
                Message(text: "D", date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .outgoing)
            ],
            [
                Message(text: "E", date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .incoming),
                Message(text: "F", date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .outgoing)
            ],
            [
                Message(text: "G", date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .incoming),
                Message(text: "H", date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .outgoing)
            ],
            [
                Message(text: "I", date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .incoming),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .incoming),
                Message(text: "J", date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 30), date: randomDate(), source: .outgoing),
                Message(text: String.randomWith(length: 100), date: randomDate(), source: .outgoing)
            ],
            nil,
            nil,
            nil,
            nil,
            nil
        ]
        
        //let friend = Friend(name: "Tracer", messages: messages, online: true)
        return messages
    }
    
    func randomDate() -> Date {
        // TODO: need to configure
        return Date()
    }
    
}
