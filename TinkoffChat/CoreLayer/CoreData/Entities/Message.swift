//
//  Message.swift
//  TinkoffChat
//
//  Created by e.bateeva on 13.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    static func fetchRequestMessages(with conversationId: String, model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let templateName = "MessagesByConversationId"
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : conversationId]) as? NSFetchRequest<Message> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest as? NSFetchRequest<Message>
    }
    
}
