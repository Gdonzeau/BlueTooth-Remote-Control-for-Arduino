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
    var nameBTModule = UITableView()
    
    //var status: Status = .disconnected 
    
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
        btNames = ["BT01", "BT02", "BT03"]
        connect.isHidden = true
        activityIndicator.isHidden = true
        
        // End Temporary
        backgroundColor = appColors.backgroundColor
        
        nameBTModule.backgroundColor = .white
        nameBTModule.register(UITableViewCell.self, forCellReuseIdentifier: "BTcell")
        nameBTModule.delegate = self
        nameBTModule.dataSource = self
        //nameBTModule.placeholder = "BT module's name"
        
        connect.setTitle("Connect", for: .normal)
        connect.backgroundColor = appColors.buttonColor
        connect.tintColor = .black
        
        disconnect.setTitle("Disconnect", for: .normal)
        disconnect.backgroundColor = appColors.buttonColor
        disconnect.tintColor = .black
        
        //activityIndicator.startAnimating()
        
        //connect.addConstraint(NSLayoutConstraint(item: connect, attribute: .height, relatedBy: .equal, toItem: connect, attribute: .width, multiplier: 0.5, constant: 0))
        //disconnect.addConstraint(NSLayoutConstraint(item: disconnect, attribute: .height, relatedBy: .equal, toItem: disconnect, attribute: .width, multiplier: 0.5, constant: 0))
        
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

extension Connection: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return btNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BTcell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(btNames[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touch BT \(indexPath.row)")
        //configurationButtons(rank:indexPath.row)
        //AlternateTableLoadButton(tableShown:false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
