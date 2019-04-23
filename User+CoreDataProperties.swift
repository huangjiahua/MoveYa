//
//  User+CoreDataProperties.swift
//  
//
//  Created by 黄嘉华 on 2018/11/8.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var key: String?
    @NSManaged public var id: Int32
    @NSManaged public var active: Bool

}
