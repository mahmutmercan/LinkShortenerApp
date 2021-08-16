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

    @NSManaged public var archived: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var long_url: String?
    @NSManaged public var shortener_url: String?
    @NSManaged public var updatedAt: Date?

}

extension LinkListItem : Identifiable {

}

