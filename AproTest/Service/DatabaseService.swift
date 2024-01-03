//
//  DatabaseService.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import CoreData

final class DatabaseService {
    
    static let shared = DatabaseService()
    
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
    
    func getCars() async -> [Car] {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            let cars = try context.fetch(fetchRequest)
            return cars
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }
    
    func editCar(id: UUID, model: String, color: String, producer: String, year: String, picture: Data) {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
  
        do {
            let cars = try context.fetch(fetchRequest)
            if let car = cars.first {
                
                car.producer = producer
                car.model = model
                car.color = color
                car.year = year
                car.picture = picture
                try context.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
