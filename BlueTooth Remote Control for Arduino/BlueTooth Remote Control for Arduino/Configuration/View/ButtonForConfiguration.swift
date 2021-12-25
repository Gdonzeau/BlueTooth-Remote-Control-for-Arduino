//
//  ButtonForConfiguration.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 17/12/2021.
//

import UIKit

class ButtonForConfiguration: UIView, UITextFieldDelegate {
    
    let button = UIButton()
    var orderTextField = UITextField()
    var nameTextField = UITextField()
    let appColors = AppColors.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        
        button.backgroundColor = appColors.buttonColor
        button.setTitle("X", for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        //button.setTitleColor(.white, for: .normal)
        
        nameTextField.backgroundColor = appColors.backGroudTextField//.lightGray
        nameTextField.layer.cornerRadius = 2
        nameTextField.layer.masksToBounds = true
        nameTextField.placeholder = "Button's name"
        nameTextField.delegate = self
        nameTextField.tintColor = appColors.fontColor
        
        orderTextField.backgroundColor = appColors.backGroudTextField
        orderTextField.layer.cornerRadius = 2
        orderTextField.layer.masksToBounds = true
        orderTextField.placeholder = "Button's order"
        orderTextField.delegate = self
        orderTextField.tintColor = appColors.fontColor
        
        
    }
    func setupConstraints() {
        let verticalStackView = UIStackView(arrangedSubviews: [button,nameTextField,orderTextField])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 2
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
            orderTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
