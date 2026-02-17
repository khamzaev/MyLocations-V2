//
//  CDLocation+CoreDataProperties.swift
//  MyLocationsST
//
//  Created by khamzaev on 12.02.2026.
//

import Foundation
import CoreData

extension CDLocation {
    
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDLocation> {
        return NSFetchRequest<CDLocation>(entityName: "CDLocation")
    }
    @NSManaged public var id: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var categoryRaw: String
    @NSManaged public var createdAt: Date
    
    @NSManaged public var city: String?
    @NSManaged public var address: String?
    @NSManaged public var photoFileName: String?
}

extension CDLocation {
    
    func toLocationItem() -> LocationItem {
        return LocationItem (
            id: id,
            latitude: latitude,
            longitude: longitude,
            city: city,
            address: address,
            createdAt: createdAt,
            name: name,
            category: LocationCategory(rawValue: categoryRaw) ?? .noCategory,
            photoFileName: photoFileName
        )
    }
}
