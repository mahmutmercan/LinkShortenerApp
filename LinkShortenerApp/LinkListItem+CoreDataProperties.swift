//
//  LinkListItem+CoreDataProperties.swift
//  
//
//  Created by Mahmut MERCAN on 10.08.2021.
//
//

import Foundation
import CoreData


extension LinkListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LinkListItem> {
        return NSFetchRequest<LinkListItem>(entityName: "LinkListItem")
    }

    @NSManaged public var defaultLink: String?
    @NSManaged public var shortenerLink: NSObject?

}
