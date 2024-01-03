//
//  CarsListController.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import UIKit

protocol CarsListControllerProtocol {
    var cars: [Car] { get set }
    func getCars() async
}

final class CarsListController: NSObject, CarsListControllerProtocol {
    
    var cars: [Car] = []
    
    private weak var view: CarsListViewProtocol?
 
    init(view: CarsListViewProtocol?) {
        super .init()
        
        self.view = view
        
        Task  {
            getCars
        }
        
        dataSourceConfirmation()
    }

    func getCars() async {
        let allCars = await DatabaseService.shared.getCars()
        
        await MainActor.run {
            cars = allCars
            self.view?.reloadTableView()
        }
    }
    
    private func dataSourceConfirmation() {
        view?.carsList.dataSource = self
    }
}

extension CarsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CarsListCell else { return UITableViewCell() }
        cell.configure(car: cars[indexPath.row])
        return cell
    }
}
