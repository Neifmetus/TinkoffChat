//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by e.bateeva on 30.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

protocol IConversationModel: class {
    var delegate: ConverationDelegate? {get set}
    func receiveMessage(text: String, date: Date)
}

class ConversationModel: IConversationModel {
    var service: ConversationListService?
    var delegate: ConverationDelegate?
    
    init(service: ConversationListService) {
        self.service = service
        self.service?.conversationDelegate = self
    }
    
    func sendMessage(text: String, userID: String) {
        service?.sendMessage(text: text, userID: userID)
    }
    
    func receiveMessage(text: String, date: Date) {
        let message = Message(text: text, messageID: nil, date: date, source: .incoming)
        delegate?.receive(message: message)
    }
}

enum MessageSource {
    case incoming
    case outgoing
}

//struct Message {
//    var text: String?
//    var messageID: String?
//    var date: Date?
//    var source: MessageSource
//}

