//
//  CarsListView.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import UIKit
import SnapKit

protocol CarsListViewProtocol: AnyObject {
    func setController(_ controller: CarsListControllerProtocol)
    func openNewCarVC()
    func reloadTableView()
    var carsList: UITableView { get set }
}

final class CarsListView: UIViewController {
    
    private var controller: CarsListControllerProtocol?
    
    private var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Cars"
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    lazy private var newCarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add new Car", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(openNewCarVC), for: .touchUpInside)
        return button
    }()
    
    var carsList: UITableView = {
        let list = UITableView()
        list.separatorStyle = .none
        list.backgroundColor = .systemMint
        list.register(CarsListCell.self, forCellReuseIdentifier: "Cell")
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        setUpLayout()
        
        carsList.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await controller?.getCars()
        }
    }
    
    private func setUpLayout() {
        view.addSubview(topLabel)
        view.addSubview(newCarButton)
        view.addSubview(carsList)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        newCarButton.snp.makeConstraints { make in
            make.centerY.equalTo(topLabel).offset(4)
            make.right.equalToSuperview().offset(-10)
        }
        
        carsList.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension CarsListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CarDetailView()
        if let controller = controller {
            let carForSetUp = controller.getCarForDetailsVC(index: indexPath.row)
            vc.setUpView(car: carForSetUp)
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
}

extension CarsListView: CarsListViewProtocol {
    @objc func openNewCarVC() {
        
        let vc = NewCarView()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func setController(_ controller: CarsListControllerProtocol) {
        self.controller = controller
    }
    
    func reloadTableView() {
            self.carsList.reloadData()
    }
}
