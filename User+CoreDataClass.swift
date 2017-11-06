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
    static func userExistInDataBase( _ name: String, _ callBack: ((User?)-> Void)) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        var user: User?
        do {
            try user = AppDelegate.viewContext.fetch(fetchRequest).first
        } catch {
            print("Error in fetching user")
        }
        callBack(user)
    }
    
    
}
