//
//  CoreDataLocationsStore.swift
//  MyLocationsST
//
//  Created by khamzaev on 12.02.2026.
//

import Foundation
import CoreData

final class CoreDataLocationsStore: LocationsStoreProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }
    
    func fetchAll() -> [LocationItem] {
        let request = CDLocation.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        do {
            let objects = try context.fetch(request)
            return objects.map { $0.toLocationItem()}
        } catch {
            print("fetch failed", error)
            return []
        }
    }
    
    func save(_ item: LocationItem) {
        let cdLocation = CDLocation(context: context)
        
        cdLocation.id = item.id
        cdLocation.latitude = item.latitude
        cdLocation.longitude = item.longitude
        cdLocation.name = item.name
        cdLocation.categoryRaw = item.category.rawValue
        cdLocation.createdAt = item.createdAt
        cdLocation.address = item.address
        cdLocation.photoFileName = item.photoFileName
        
        do {
            try context.save()
        } catch {
            print("Save failed:", error)
        }
    }
    
    func update(_ item: LocationItem) {

        do {
            let request: NSFetchRequest<CDLocation> = CDLocation.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            
            guard let cd = try context.fetch(request).first else {
                assertionFailure("Location not found for update")
                return
            }
            cd.name = item.name
            cd.categoryRaw = item.category.rawValue
            cd.photoFileName = item.photoFileName
            
            try context.save()
            
        } catch {
            print("CoreData update error:", error)
        }
    }
    
    func delete(id: UUID) {
        let request = CDLocation.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let objects = try context.fetch(request)
            objects.forEach { context.delete($0)}
            try context.save()
        } catch {
            print("Delete failed:", error)
        }
    }
}
