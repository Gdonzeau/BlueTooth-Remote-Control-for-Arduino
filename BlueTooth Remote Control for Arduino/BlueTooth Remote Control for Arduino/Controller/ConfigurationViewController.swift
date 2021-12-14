//
//  ConfigurationViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class ConfigurationViewController: UIViewController {
    let first = FirstChildViewController()
    //let first = PickerViewBluetoothAvailableViewController()
    //let second = SecondChildViewController()
    let second = TableViewController()
    
    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        super.viewDidLoad()
        
        self.addChild(first)
        self.addChild(second)
        
        self.view.addSubview(first.view)
        self.view.addSubview(second.view)
        
        first.didMove(toParent: self)
        second.didMove(toParent: self)
        
        
        first.view.translatesAutoresizingMaskIntoConstraints = false
        second.view.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            first.view.topAnchor.constraint(equalTo: margins.topAnchor),
            first.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            first.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            //first.view.bottomAnchor.constraint(equalTo: second.view.topAnchor),
            first.view.heightAnchor.constraint(equalToConstant: 200),
            
            second.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            second.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            second.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            second.view.heightAnchor.constraint(equalToConstant: 200)
            
            
        ])
    }
}
