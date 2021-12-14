//
//  DatasReceived.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 15/12/2021.
//

import UIKit

class DatasReceived: UIView {
    
    var titleData01 = UILabel()
    var contentData01 = UILabel()
    var titleData02 = UILabel()
    var contentData02 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = .lightGray
        titleData01.text = "Data01 :"
        titleData02.text = "Data02 :"
        contentData01.text = "0,23"
        contentData02.text = "3,134"
        
        titleData01.addConstraint(NSLayoutConstraint(item: titleData01, attribute: .height, relatedBy: .equal, toItem: titleData01, attribute: .width, multiplier: 0.5, constant: 0))
        contentData01.addConstraint(NSLayoutConstraint(item: contentData01, attribute: .height, relatedBy: .equal, toItem: contentData01, attribute: .width, multiplier: 0.5, constant: 0))
        titleData02.addConstraint(NSLayoutConstraint(item: titleData02, attribute: .height, relatedBy: .equal, toItem: titleData02, attribute: .width, multiplier: 0.5, constant: 0))
        contentData02.addConstraint(NSLayoutConstraint(item: contentData02, attribute: .height, relatedBy: .equal, toItem: contentData02, attribute: .width, multiplier: 0.5, constant: 0))
        
        titleData01.contentMode = .scaleAspectFit
        contentData01.contentMode = .scaleAspectFit
        titleData02.contentMode = .scaleAspectFit
        contentData02.contentMode = .scaleAspectFit
        
        let horizontalStackView = UIStackView(arrangedSubviews: [titleData01,contentData01,titleData02,contentData02])
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
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
