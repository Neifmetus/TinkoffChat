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
        
        return fetchRequest.copy() as? NSFetchRequest<Message>
    }
    
    static func saveMessage(with conversationId: String, text: String, isIncoming: Bool) {
        guard let context = CoreDataManager.coreDataStack?.saveContext else {
            print("Unable to get context")
            return
        }
        
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Unable to get model")
            return
        }
        
        if let fetchRequest = Conversation.fetchRequestMessages(with: conversationId, model: model) {
            do {
                let сonversation = try context.fetch(fetchRequest).first
                let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message
                message?.conversation = сonversation
                message?.date = Date()
                message?.isIncoming = isIncoming
                message?.text = text
                message?.messageId = "\(Date().timeIntervalSinceReferenceDate)"
            
                CoreDataManager.save()
            } catch {
                print("Unable to get conversation by id: \(conversationId)")
            }
        }
    }
}
