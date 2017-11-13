//
//  ConversationDataProvider.swift
//  TinkoffChat
//
//  Created by e.bateeva on 13.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationDataProviderDelegate {
    func deleteFriends(at paths: [IndexPath])
    func insertFriends(at paths: [IndexPath])
    func updateFriends(at paths: [IndexPath])
}

class ConversationDataProvider: NSObject {
    var delegate: IConversationDataProviderDelegate?
    var fetchedResultsController: NSFetchedResultsController<Message>
    
    init(delegate: IConversationDataProviderDelegate, conversationId: String) {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest as! NSFetchRequest<Message>,
                                                                      managedObjectContext: context,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
        
        super.init()
        
        self.delegate = delegate
        fetchedResultsController.delegate = self
    }
}

extension ConversationDataProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // beginUpdates
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // endUpdates
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                                                didChange anObject: Any,
                                                at indexPath: IndexPath?,
                                                for type: NSFetchedResultsChangeType,
                                                newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                delegate?.deleteFriends(at: [indexPath])
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.insertFriends(at: [newIndexPath])
            }
        case .move:
            if let indexPath = indexPath {
                delegate?.deleteFriends(at: [indexPath])
            }
            
            if let newIndexPath = newIndexPath {
                delegate?.insertFriends(at: [newIndexPath])
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.updateFriends(at: [indexPath])
            }
    }
}


