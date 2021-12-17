//
//  TwoButtonsLine.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 17/12/2021.
//

import UIKit

class TwoButtonsLine: UIView {
    let appColors = AppColors.shared
    
    var saveButton = UIButton()
    var loadButton = UIButton()
    
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
        
        let buttons = [saveButton,loadButton]
        
        for button in buttons {
            
            button.backgroundColor = appColors.buttonColor
            button.setTitle("X", for: .normal)
            button.contentMode = .scaleAspectFit
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [saveButton,loadButton])
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
            saveButton.heightAnchor.constraint(equalToConstant: 80),
            loadButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }

}
