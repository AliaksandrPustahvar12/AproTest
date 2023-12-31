//
//  CarsListCell.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import UIKit
import SnapKit

class CarsListCell: UITableViewCell {

   private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
  private let producerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
   private let modelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
   private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
   private let colorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCell()
        setUpLayout()
    }
    
    private func setUpCell() {
        
        self.contentView.backgroundColor = .systemMint.withAlphaComponent(0.9)
        self.contentView.addSubview(carImageView)
        self.contentView.addSubview(producerLabel)
        self.contentView.addSubview(modelLabel)
        self.contentView.addSubview(yearLabel)
        self.contentView.addSubview(colorLabel)
        
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemMint.cgColor
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
    }
    
    private func setUpLayout() {
        
        carImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.height.equalTo(80)
            make.width.equalTo(120)
        }
        
        producerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(carImageView.snp.right).offset(12)
            make.height.equalTo(30)
        }
        
        modelLabel.snp.makeConstraints { make in
            make.top.equalTo(producerLabel.snp.bottom).offset(16)
            make.left.equalTo(carImageView.snp.right).offset(12)
            make.height.equalTo(26)
       }
        
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(carImageView.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(carImageView.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(car: Car) {
        producerLabel.text = car.producer
        modelLabel.text = car.model
        colorLabel.text = car.color
        yearLabel.text = car.year
        
        if let imageData = car.picture {
            DispatchQueue.main.async {
                self.carImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override func prepareForReuse() {
       carImageView.image = nil
    }
}
