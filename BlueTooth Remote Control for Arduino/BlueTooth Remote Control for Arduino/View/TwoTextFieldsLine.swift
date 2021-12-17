//
//  TwoTextFieldsLine.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 17/12/2021.
//

import UIKit

class TwoTextFieldsLine: UIView {
    var appColors = AppColors.shared
    var dataName01 = UITextField()
    var dataName02 = UITextField()
    
    
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
        
        dataName01.placeholder = "Data n°1"
        dataName02.placeholder = "Data n°2"
        
        
        dataName01.backgroundColor = .lightGray
        dataName02.backgroundColor = .lightGray
        
        
        dataName01.contentMode = .scaleAspectFit
        dataName02.contentMode = .scaleAspectFit
        
        let horizontalStackView = UIStackView(arrangedSubviews: [dataName01,dataName02])
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
            dataName01.heightAnchor.constraint(equalToConstant: 30),
            dataName02.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
}
