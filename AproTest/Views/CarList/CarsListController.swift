//
//  CarsListController.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import Foundation

protocol CarsListControllerProtocol {
    var cars: [Car] { get set }
    func getCars() async
}

final class CarsListController: CarsListControllerProtocol {
    
    var cars: [Car] = []
    
    private weak var view: CarsListViewProtocol?
 
    init(view: CarsListViewProtocol?) {
        self.view = view
        
        Task {
            let allCars = await DatabaseService.shared.getCars()

            await MainActor.run {
                cars = allCars
                self.view?.reloadTableView()
            }
        }
    }

    func getCars() async {
        let allCars = await DatabaseService.shared.getCars()
        
        await MainActor.run {
            cars = allCars
            self.view?.reloadTableView()
        }
    }
}
