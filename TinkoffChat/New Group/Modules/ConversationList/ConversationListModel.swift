//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 28.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit

protocol IConversationListModel: class {
    var delegate: IConversationListModelDelegate? {get set}
    func updateConversationListWith(friends: [Friend])
}

class ConversationListModel: IConversationListModel {
    var service: ConversationListService?
    var delegate: IConversationListModelDelegate?
    
    init() {
        self.service = ConversationListService(delegate: self)
    }
    
    func findOnlineFriends() {
        
    }
    
    func updateConversationListWith(friends: [Friend]) {
        delegate?.reloadFriends(friends)
    }
    
}
