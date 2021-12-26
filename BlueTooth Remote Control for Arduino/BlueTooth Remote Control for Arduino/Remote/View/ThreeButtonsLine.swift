//
//  HorizontalViewWithButtons.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 13/12/2021.
//

import UIKit

class ThreeButtonsLine: UIView {
    //let appColors = AppColors.shared
    
    var remoteButton01 = UIButton()
    var remoteButton02 = UIButton()
    var remoteButton03 = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = AppColors.backgroundColorArduino
        
        let buttons = [remoteButton01,remoteButton02,remoteButton03]
        
        for button in buttons {
            button.backgroundColor = AppColors.buttonColor
            button.contentMode = .scaleAspectFit
            button.layer.cornerRadius = 24
            button.layer.masksToBounds = true
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [remoteButton01,remoteButton02,remoteButton03])
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
            remoteButton01.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            remoteButton02.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            remoteButton03.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}

