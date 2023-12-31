//
//  CarsListController.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import UIKit
import CoreData

protocol CarsListControllerProtocol {
    var cars: [Car] { get set }
    func getCars() async
}


final class CarsListController: CarsListControllerProtocol {
    
    var cars: [Car] = []
    
    private weak var view: CarsListViewProtocol?
    private let dbService = DatabaseService()
    
    
    init(view: CarsListViewProtocol?) {
        self.view = view
        
        Task {
            await getCars()
        }
    }

    func getCars() async {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            cars = try dbService.context.fetch(fetchRequest)
            
            await MainActor.run {
                self.view?.reloadTableView()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
