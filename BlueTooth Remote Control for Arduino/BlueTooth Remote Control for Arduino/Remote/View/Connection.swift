//
//  Connection.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 14/12/2021.
//

import UIKit

class Connection: UIView {
    
    
    var appColors = AppColors.shared
    var connect = UIButton() // Press this button to connect to BT
    var disconnect = UIButton() // Press this button to disconnect from BT
    var activityIndicator = UIActivityIndicatorView()
    var btNames: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        // Temporary, for tests
        
        btNames = []
        connect.isHidden = true
        activityIndicator.isHidden = true
        
        // End Temporary
        backgroundColor = appColors.backgroundColor
        
        connect.setTitle("Connect", for: .normal)
        connect.backgroundColor = appColors.buttonColor
        connect.tintColor = .black
        
        disconnect.setTitle("Disconnect", for: .normal)
        disconnect.backgroundColor = appColors.buttonColor
        disconnect.tintColor = .black
        
        connect.contentMode = .scaleAspectFit
        disconnect.contentMode = .scaleAspectFit
        
        let horizontalStackView = UIStackView(arrangedSubviews: [connect,disconnect,activityIndicator])//[nameBTModule,connect,disconnect,activityIndicator])
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
