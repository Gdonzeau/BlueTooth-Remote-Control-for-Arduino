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
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        
        nameTextField.backgroundColor = .white
        nameTextField.layer.cornerRadius = 2
        nameTextField.layer.masksToBounds = true
        nameTextField.placeholder = "Button's name"
        nameTextField.delegate = self
        
        orderTextField.backgroundColor = .white
        orderTextField.layer.cornerRadius = 2
        orderTextField.layer.masksToBounds = true
        orderTextField.placeholder = "Button's order"
        orderTextField.delegate = self
        
        
    }
    func setupConstraints() {
        let verticalStackView = UIStackView(arrangedSubviews: [button,nameTextField,orderTextField])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        //verticalStackView.distribution = .fillEqually
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
