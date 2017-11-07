//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by e.bateeva on 07.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let coreDataStack = CoreDataStack()
    
    func getAppUser() -> AppUser? {
        if let context = self.coreDataStack.saveContext {
            return findOrInsertAppUser(in: context)
        }
        
        return nil
    }
    
    func save() {
        if let context = self.coreDataStack.saveContext {
            self.coreDataStack.performSave(context: context, completion: {
                print("Save context success!")
            })
        } else {
            print("Unable to save context!")
        }
    }
    
    func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not availible in context!")
            assert(false)
            return nil
        }
        
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUSer: \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }

}
