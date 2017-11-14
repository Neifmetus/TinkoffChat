//
//  ConversationDataProvider.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 14.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationDataProviderDelegate {
    func deleteMessages(at paths: [IndexPath])
    func insertMessages(at paths: [IndexPath])
    func updateMessages(at paths: [IndexPath])
}

class ConversationDataProvider: NSObject {
    var delegate: IConversationDataProviderDelegate?
    var fetchedResultsController: NSFetchedResultsController<Message>
    
    init(delegate: IConversationDataProviderDelegate, conversationId: String) {
        self.delegate = delegate
        let context = CoreDataManager.coreDataStack?.saveContext
        let model = context?.persistentStoreCoordinator?.managedObjectModel
        let fetchRequest = Message.fetchRequestMessages(with: conversationId, model: model!)
        
        fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest!,
                                                                    managedObjectContext: context!,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        super.init()
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
                delegate?.deleteMessages(at: [indexPath])
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.insertMessages(at: [newIndexPath])
            }
        case .move:
            if let indexPath = indexPath {
                delegate?.deleteMessages(at: [indexPath])
            }
            
            if let newIndexPath = newIndexPath {
                delegate?.insertMessages(at: [newIndexPath])
            }
        case .update:
            if let indexPath = indexPath {
                delegate?.updateMessages(at: [indexPath])
            }
        }
    }
}
