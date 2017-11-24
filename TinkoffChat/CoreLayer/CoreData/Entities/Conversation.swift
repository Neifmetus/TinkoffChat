//
//  Conversation.swift
//  TinkoffChat
//
//  Created by e.bateeva on 13.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    
    static func fetchRequestMessages(with id: String, model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationById"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : id]) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest.copy() as? NSFetchRequest<Conversation>
    }
    
    static func insertConversation(in context: NSManagedObjectContext, userId: String) -> Conversation? {
        let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation
        conversation?.conversationId = userId
        conversation?.isOnline = true
        
        return conversation
    }
}
