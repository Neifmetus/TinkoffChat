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
    
    static func findOrInsertUser(with: String, in context: NSManagedObjectContext) -> User? {
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
    
    static func fetchRequestUser(with: String, model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "User"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : with]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest
    }
    
    static func insertAppUser(with: String, in context: NSManagedObjectContext) -> User? {
        return insertUser(in: context, name: "Name Surname", additionalInfo: "Some info", image: nil, userId: User.generateUserIdString())
    }
    
    static func insertUser(in context: NSManagedObjectContext, name: String, additionalInfo: String, image: Data?, userId: String) -> User? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        
        user?.name = name
        user?.additionalInfo = additionalInfo
        user?.image = image
        user?.userId = userId
        
        return user
    }
}
