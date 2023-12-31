//
//  DatabaseService.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import CoreData

final class DatabaseService {
    
    let context: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Car")
        container.loadPersistentStores { description, error in
            if error != nil {
                description.shouldMigrateStoreAutomatically = true
                description.shouldInferMappingModelAutomatically = true
            }
        }
        context = container.viewContext
    }
}
