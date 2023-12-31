//
//  CarDetailView.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import UIKit
import CoreData

class CarDetailView: UIViewController {
    
    private let dbService = DatabaseService()
    
   lazy private var imageButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        return button
    }()
    
   lazy private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .brown
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
      return button
    }()
    
    private let producerLabel: UILabel = {
        let label = UILabel()
        label.text = "Producer:"
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    private let producerTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textField.textColor = .brown
        textField.textAlignment = .left
        textField.isEnabled = false
        return textField
    }()
    
    private let modelLabel: UILabel = {
        let label = UILabel()
        label.text = "Model:"
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    private let modelTextField: UITextField = {
         let textField = UITextField()
         textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
         textField.textColor = .brown
         textField.textAlignment = .left
         textField.isEnabled = false
         return textField
     }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "Year:"
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    private let yearTextField: UITextField = {
         let textField = UITextField()
         textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
         textField.textColor = .brown
         textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.isEnabled = false
         return textField
     }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Color:"
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    private let colorTextField: UITextField = {
         let textField = UITextField()
         textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
         textField.textColor = .brown
         textField.adjustsFontSizeToFitWidth = true
         textField.textAlignment = .left
         textField.isEnabled = false
         return textField
     }()
    
   lazy private var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        button.tintColor = .brown
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.brown.cgColor
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var isEdit = false
    
    private var id: UUID?
    
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        imagePicker.delegate = self
        setUpLayout()
    }
    
    private func setUpLayout() {
        view.addSubview(closeButton)
        view.addSubview(imageButton)
        view.addSubview(producerLabel)
        view.addSubview(producerTextField)
        view.addSubview(modelLabel)
        view.addSubview(modelTextField)
        view.addSubview(yearLabel)
        view.addSubview(yearTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorTextField)
        view.addSubview(editButton)
        
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(60)
            make.size.equalTo(30)
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.height.equalTo(140)
            make.width.equalTo(210)
        }
        
        producerTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(producerLabel.snp.right).offset(5)
            make.height.equalTo(35)
        }
        
        producerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(producerTextField).offset(3)
            make.left.equalToSuperview().offset(50)
        }
        
        modelLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.centerY.equalTo(modelTextField).offset(2)
        }

        
        modelTextField.snp.makeConstraints { make in
            make.top.equalTo(producerTextField.snp.bottom).offset(10)
            make.left.equalTo(modelLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(colorTextField)
        }
        
        colorTextField.snp.makeConstraints { make in
            make.top.equalTo(modelTextField.snp.bottom).offset(10)
            make.left.equalTo(colorLabel.snp.right).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(modelTextField.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.right.equalTo(yearTextField.snp.left).offset(-5)
            make.centerY.equalTo(yearTextField)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(colorTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func setUpView(car: Car) {
        if let imageData = car.picture {
            imageButton.setImage(UIImage(data: imageData), for: .normal)
        }
        producerTextField.text = car.producer
        modelTextField.text = car.model
        colorTextField.text = car.color
        yearTextField.text = car.year
        self.id = car.id
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func imageButtonTapped() {
        if isEditing {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        } else {
            return
        }
    }
    
    @objc private func editButtonTapped() {
        if !isEditing {
            
            self.isEditing = true
            producerTextField.isEnabled = true
            modelTextField.isEnabled = true
            colorTextField.isEnabled = true
            yearTextField.isEnabled = true
            editButton.setTitle("Save changes", for: .normal)
        } else {
            isEditing = false
            producerTextField.isEnabled = false
            modelTextField.isEnabled = false
            colorTextField.isEnabled = false
            yearTextField.isEnabled = false
            editButton.setTitle("Edit", for: .normal)
            updateCarInfo()
        }
    }
    
    private func updateCarInfo() {
        guard let id = self.id else { return }
        
        guard let producer = producerTextField.text , !producer.isEmpty, let model = modelTextField.text, !model.isEmpty, let year = yearTextField.text, !year.isEmpty, let color = colorTextField.text, !color.isEmpty, let picture = imageButton.imageView?.image else { print("EMPTY")
            showAlert()
            return
        }
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
           let cars = try dbService.context.fetch(fetchRequest)
            if let car = cars.first {
            
                car.producer = producer
                car.model = model
                car.color = color
                car.year = year
                car.picture = picture.pngData()
                print(producer, model, year, color)
                try dbService.context.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "You need to enter all information about Car", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension CarDetailView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.imageButton.setImage(pickedImage, for: .normal)
            }
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
