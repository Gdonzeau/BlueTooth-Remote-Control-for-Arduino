//
//  HorizontalViewWithOrders.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 17/12/2021.
//

import UIKit
/*
class ThreeTextFieldsLine: UIView {
    var appColors = AppColors.shared
    var orderForButton01 = UITextField()
    var orderForButton02 = UITextField()
    var orderForButton03 = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = appColors.backgroundColor
        let textFields = [orderForButton01,orderForButton02,orderForButton03]
        
        for textField in textFields {
            textField.placeholder = "Orders"
            textField.backgroundColor = .white
            textField.contentMode = .scaleAspectFit
            textField.layer.cornerRadius = 2
            textField.layer.masksToBounds = true
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [orderForButton01,orderForButton02,orderForButton03])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 5
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStackView)
        
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            orderForButton01.heightAnchor.constraint(equalToConstant: 30),
            orderForButton02.heightAnchor.constraint(equalToConstant: 30),
            orderForButton03.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
}
*/
