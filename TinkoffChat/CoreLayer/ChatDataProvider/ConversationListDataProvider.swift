//
//  ConversationDataProvider.swift
//  TinkoffChat
//
//  Created by e.bateeva on 13.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol IConversationListDataProviderDelegate {
    func deleteFriends(at paths: [IndexPath])
    func insertFriends(at paths: [IndexPath])
    func updateFriends(at paths: [IndexPath])
    
    func beginUpdates()
    func endUpdates()
}

class ConversationListDataProvider: NSObject {
    var delegate: IConversationListDataProviderDelegate?
    var fetchedResultsController: NSFetchedResultsController<User>
    var tableView: UITableView
    
    init(delegate: IConversationListDataProviderDelegate, tableView: UITableView) {
        self.delegate = delegate
        self.tableView = tableView
        
        let context = CoreDataManager.coreDataStack?.saveContext
        let model = context?.persistentStoreCoordinator?.managedObjectModel
        let fetchRequest = User.fetchRequestFriends(model: model!)

        let onlineSortDescriptor = NSSortDescriptor(key: "conversations.isOnline", ascending: true)
        fetchRequest?.sortDescriptors = [onlineSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController<User>(fetchRequest: fetchRequest!,
                                                                      managedObjectContext: context!,
                                                                      sectionNameKeyPath: "conversations.isOnline",
                                                                      cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        self.performFetch()
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch")
        }
    }
}

extension ConversationListDataProvider: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //DispatchQueue.main.async {
            self.tableView.beginUpdates()
        //}
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //DispatchQueue.main.async {
            self.tableView.endUpdates()
        //}
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                                                didChange anObject: Any,
                                                at indexPath: IndexPath?,
                                                for type: NSFetchedResultsChangeType,
                                                newIndexPath: IndexPath?) {
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    //delegate?.deleteFriends(at: [indexPath])
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            case .insert:
                if let newIndexPath = newIndexPath {
//                    DispatchQueue.main.async {
//                        self.delegate?.insertFriends(at: [newIndexPath])
//                    }
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath {
                    //delegate?.deleteFriends(at: [indexPath])
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }

                if let newIndexPath = newIndexPath {
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    //delegate?.updateFriends(at: [indexPath])
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
        }
    }
}

