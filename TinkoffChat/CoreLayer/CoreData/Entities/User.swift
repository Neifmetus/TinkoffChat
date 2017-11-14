//
//  User.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 06.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    static func generateUserIdString() -> String {
        return "Test userId"
    }
    
    static func findOrInsertAppUser(with: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not availible in context!")
            assert(false)
            return nil
        }
        
        var appUser: User?
        guard let fetchRequest = User.fetchRequestUser(with: with, model: model) else {
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
            appUser = User.insertAppUser(with: with, in: context)
        }
        
        return appUser
    }
    
    static func findOrInsertUser(with id: String, name: String, isOnline: Bool, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Unable to get model")
            return nil
        }
        
        var user: User?
        if let fetchRequest = User.fetchRequestUser(with: id, model: model) {
            do {
                if let foundedUser = try context.fetch(fetchRequest).first {
                    foundedUser.conversations?.isOnline = isOnline
                    user = foundedUser
                }
            } catch {
                print("Failed to fetch User: \(error)")
                return nil
            }
        } else {
            user = insertUser(in: context, name: name, userId: id)
            user?.conversations?.isOnline = isOnline
            user?.conversations?.conversationId = id
        }
        
        CoreDataManager.save()
        return user
    }
    
    static func saveUser(with id: String, name: String, isOnline: Bool) {
        guard let context = CoreDataManager.coreDataStack?.saveContext else {
            print("Unable to get context")
            return
        }
        
        _ = findOrInsertUser(with: id, name: name, isOnline: isOnline, in: context)
    }
    
    static func fetchRequestUser(with: String, model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "User"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : with]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest
    }
    
    static func fetchRequestFriends(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "Friends"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest.copy() as? NSFetchRequest<User>
    }
    
    static func insertAppUser(with: String, in context: NSManagedObjectContext) -> User? {
        let appUser = insertUser(in: context, name: "Name Surname", userId: User.generateUserIdString())
        appUser?.additionalInfo = "Some info"
        appUser?.image = nil
        
        return appUser
    }
    
    static func insertUser(in context: NSManagedObjectContext, name: String, userId: String) -> User? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        user?.name = name
        user?.userId = userId
        
        return user
    }
}
