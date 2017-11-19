//
//  User+CoreDataClass.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 05/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    static func findOrCreateUser(_ name: String) throws -> User  {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
             let matches = try appDelegate.viewContext.fetch(fetchRequest)
            if matches.count > 0 {
              assert(matches.count == 1 , "Database incosistency")
              return matches.first!
            }
       } catch  {
            throw error
        }
        let user = User(context: appDelegate.viewContext)
        user.name = name
        appDelegate.saveContext()
        return user
    }
    
    static func getListOfUserInBackground() throws -> [User] {
      let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
      var users = [User]()
      appDelegate.persistentContainer.performBackgroundTask { context in
                if let _users = try? context.fetch(fetchRequest) {
                    users = _users
                    print("Start printing Database------->")
                    for user in users {
                     print(user.description)
                    }
            }
        }
        return  users
        
        //always prefer to user
//        appDelegate.viewContext.perform {
//            
//        }
    }
    
    
    public override var description: String {
        return super.description + self.name!
    }
}
