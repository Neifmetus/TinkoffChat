//
//  ConversationListService.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 29.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

protocol IConversationListService: class {
    func didFound(friend: Friend)
    func didLost(friend: Friend)
    func didReceive(message: Message)
}

class ConversationListService: IConversationListService {
    var delegate: IConversationListModel?
    
    init(delegate: IConversationListModel) {
        self.delegate = delegate
    }
    
    func didFound(friend: Friend) {
        
    }
    
    func didLost(friend: Friend) {
        
    }
    
    func didReceive(message: Message) {
        
    }
    
    
}
