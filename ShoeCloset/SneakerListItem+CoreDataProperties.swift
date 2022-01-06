//
//  SneakerListItem+CoreDataProperties.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/10/21.
//
//

import Foundation
import CoreData


extension SneakerListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SneakerListItem> {
        return NSFetchRequest<SneakerListItem>(entityName: "SneakerListItem")
    }

    @NSManaged public var brand: String?
    @NSManaged public var name: String?
    @NSManaged public var purchasePrice: Double
    @NSManaged public var retailPrice: Double
    @NSManaged public var date: String?
    @NSManaged public var styleID: String?
    @NSManaged public var image: Data?
    @NSManaged public var mapLat: Double
    @NSManaged public var mapLong: Double
    @NSManaged public var mapName: String?

}

extension SneakerListItem : Identifiable {

}
