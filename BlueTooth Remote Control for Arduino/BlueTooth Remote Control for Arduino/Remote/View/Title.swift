//
//  Title.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 19/12/2021.
//

import UIKit

class Title: UIView {

    let appColors = AppColors.shared
    
    var title = UILabel()
    
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
        title.contentMode = .scaleAspectFit
        title.textAlignment = .center
        
        let horizontalStackView = UIStackView(arrangedSubviews: [title])
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
            title.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }

}
