//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 05.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private var storeURL: URL {
        get {
            let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("Store.sqlite")
            
            return url
        }
    }

    // NSManagedObjectModel
    private let managedObjectModelName = "Storage"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                guard let modelURL = Bundle.main.url(forResource:
                    managedObjectModelName, withExtension: "momd") else {
                        print("Empty model url!")
                        return nil
                }
                
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            
            return _managedObjectModel
        }
    }
    
    // NSPersistentStoreCoordinator
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if _persistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("Empty managed object model")
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                        configurationName: nil,
                                                                        at: storeURL,
                                                                        options: nil)
                } catch {
                    assert(false, "Error adding persistent store to coordinator: \(error)")
                }
            }
            
            return _persistentStoreCoordinator
        }
    }
    
    // NSManagedObjectContext (master)
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType:
                    NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("Empty persistent store coordinator!")
                    
                    return nil
                }
                
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            
            return _masterContext
        }
    }
    
    // NSManagedObjectContext (main)
    private var _mainContext: NSManagedObjectContext?
    private var mainContext: NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType:
                    NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            
            return _mainContext
        }
    }
    
    // NSManagedObjectContext (save)
    private var _saveContext: NSManagedObjectContext?
    private var saveContext: NSManagedObjectContext? {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType:
                    NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No main context!")
                    
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            
            return _saveContext
        }
    }
    
    public func performSave(context: NSManagedObjectContext, completion: (() -> Void)? ) {
        
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completion: completion)
                } else {
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
    
}
