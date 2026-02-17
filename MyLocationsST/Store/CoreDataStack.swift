//
//  CoreDataStack.swift
//  MyLocationsST
//
//  Created by khamzaev on 12.02.2026.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MyLocationsST")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core data Store failed: \(error)")
            }
        }
        
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}
