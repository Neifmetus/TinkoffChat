//
//  ConversationListAssembly.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 28.10.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit
import Foundation

class ConversationListAssembly {
    
    func conversationListViewController() -> ConversationListViewController {
        return ConversationListViewController()
    }
    
    private func conversationListModel() -> IConversationListModel {
        return ConversationListModel()
    }
}
