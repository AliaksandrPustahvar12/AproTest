//
//  DatabaseService.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import CoreData

final class DatabaseService {
    
    static let shared = DatabaseService()
    
   private let context: NSManagedObjectContext
    
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
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func editCar() {

        do {
                try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveNewCar(car: CarModel) {
        
        let newCar = Car(context: context)
        newCar.id = .init()
        newCar.producer = car.producer
        newCar.model = car.model
        newCar.color = car.color
        newCar.year = car.year
        newCar.picture = car.picture
        
        do {
                try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
