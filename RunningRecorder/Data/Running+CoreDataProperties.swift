//
//  Running+CoreDataProperties.swift
//  
//
//  Created by 黄嘉华 on 2018/11/4.
//
//

import Foundation
import CoreData


extension Running {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Running> {
        return NSFetchRequest<Running>(entityName: "Running")
    }

    @NSManaged public var userID: Int32
    @NSManaged public var beginningTime: NSDate?
    @NSManaged public var duration: Int32
    @NSManaged public var distance: Double
    @NSManaged public var speed: Double

}
