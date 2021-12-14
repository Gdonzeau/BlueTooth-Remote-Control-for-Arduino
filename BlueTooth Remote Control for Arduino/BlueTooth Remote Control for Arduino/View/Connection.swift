//
//  Connection.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 14/12/2021.
//

import UIKit

class Connection: UIView {
    
    var connect = UIButton() // Press this button to connect to BT
    var disconnect = UIButton() // Press this button to disconnect from BT
    var activityIndicator = UIActivityIndicatorView()
    var nameBTModule = UITextField()
    
    var status:Status = .disconnected
    
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
        
        nameBTModule.backgroundColor = .white
        nameBTModule.placeholder = "BT module's name"
        
        connect.setTitle("Connect", for: .normal)
        connect.backgroundColor = .darkGray
        connect.tintColor = .black
        
        disconnect.setTitle("Disconnect", for: .normal)
        disconnect.backgroundColor = .darkGray
        disconnect.tintColor = .black
        
        activityIndicator.startAnimating()
        
        connect.addConstraint(NSLayoutConstraint(item: connect, attribute: .height, relatedBy: .equal, toItem: connect, attribute: .width, multiplier: 0.5, constant: 0))
        disconnect.addConstraint(NSLayoutConstraint(item: disconnect, attribute: .height, relatedBy: .equal, toItem: disconnect, attribute: .width, multiplier: 0.5, constant: 0))
        
        connect.contentMode = .scaleAspectFit
        disconnect.contentMode = .scaleAspectFit
        
        let horizontalStackView = UIStackView(arrangedSubviews: [nameBTModule,connect,disconnect,activityIndicator])
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
