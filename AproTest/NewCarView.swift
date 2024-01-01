//
//  NewCarView.swift
//  AproTest
//
//  Created by Aliaksandr Pustahvar on 31.12.23.
//

import UIKit

class NewCarView: UIViewController {
    
    private var topLabel: UILabel = {
        let label = UILabel()
        label.text = "New Car"
        label.textColor = .brown
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        return label
    }()
    
    lazy private var imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Press here to add Car picture", for: .normal)
        button.setTitleColor(.brown, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
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
    
    private let producerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Car producer"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = .systemMint
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .brown
        return textField
    }()
    
    private let modelTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Car model"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = .systemMint
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .brown
        return textField
    }()
    
    private let yearTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Car year"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = .systemMint
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .brown
        return textField
    }()
    
    private let colorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Car color"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = .systemMint
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .brown
        return textField
    }()
    
    lazy private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Car", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        button.tintColor = .brown
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.brown.cgColor
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        imagePicker.delegate = self
        producerTextField.delegate = self
        modelTextField.delegate = self
        yearTextField.delegate = self
        colorTextField.delegate = self
        setUpLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpLayout() {
        view.addSubview(topLabel)
        view.addSubview(closeButton)
        view.addSubview(imageButton)
        view.addSubview(producerTextField)
        view.addSubview(modelTextField)
        view.addSubview(yearTextField)
        view.addSubview(colorTextField)
        view.addSubview(saveButton)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(topLabel)
            make.size.equalTo(30)
        }
        
        imageButton.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(150)
        }
        
        producerTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        modelTextField.snp.makeConstraints { make in
            make.top.equalTo(producerTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(modelTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        colorTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(colorTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func imageButtonTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() throws {
        guard let producer = producerTextField.text , !producer.isEmpty, let model = modelTextField.text, !model.isEmpty, let year = yearTextField.text, !year.isEmpty, let color = colorTextField.text, !color.isEmpty, let picture = imageButton.imageView?.image else {
            showAlert()
            return
        }
        
        let car = Car(context: DatabaseService.shared.context)
        car.id = .init()
        car.producer = producer
        car.model = model
        car.color = color
        car.year = year
        car.picture = picture.pngData()
        try DatabaseService.shared.context.save()
        dismiss(animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "You need to enter all information about Car", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewCarView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageButton.titleLabel?.text = nil
            imageButton.tintColor = .clear
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

extension NewCarView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
