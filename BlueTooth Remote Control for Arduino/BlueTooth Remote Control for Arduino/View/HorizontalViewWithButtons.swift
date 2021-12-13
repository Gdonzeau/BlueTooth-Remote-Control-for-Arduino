//
//  HorizontalViewWithButtons.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 13/12/2021.
//

import UIKit

class HorizontalViewWithButtons: UIView {

    var remoteButton01 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var remoteButton02 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var remoteButton03 = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        //remoteButton01.index(ofAccessibilityElement: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        remoteButton01.setTitle("Button 01", for: .normal)
        remoteButton02.setTitle("Button 02", for: .normal)
        remoteButton03.setTitle("Button 03", for: .normal)
        
        remoteButton01.backgroundColor = .red
        remoteButton02.backgroundColor = .blue
        remoteButton03.backgroundColor = .green
        
        remoteButton01.addConstraint(NSLayoutConstraint(item: remoteButton01, attribute: .height, relatedBy: .equal, toItem: remoteButton01, attribute: .width, multiplier: 1, constant: 0))
        remoteButton02.addConstraint(NSLayoutConstraint(item: remoteButton02, attribute: .height, relatedBy: .equal, toItem: remoteButton02, attribute: .width, multiplier: 1, constant: 0))
        remoteButton03.addConstraint(NSLayoutConstraint(item: remoteButton03, attribute: .height, relatedBy: .equal, toItem: remoteButton03, attribute: .width, multiplier: 1, constant: 0))
        
        remoteButton01.contentMode = .scaleAspectFit
        remoteButton02.contentMode = .scaleAspectFit
        remoteButton03.contentMode = .scaleAspectFit
        
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
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }

}
