//
//  ConfigurationViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class ConfigurationViewController: UIViewController {
    let first = FirstChildViewController()
    //var firstStackView = UIStackView()
    let secondStackView = UIStackView()
    let finalStackView = UIStackView()
    let second = PickerViewBluetoothAvailableViewController()
    //let second = SecondChildViewController()
    //let second = TableViewController()
    
    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        super.viewDidLoad()
        

        /*
        self.addChild(first)
        self.addChild(second)
        
        self.view.addSubview(first.view)
        self.view.addSubview(second.view)
        
        first.didMove(toParent: self)
        second.didMove(toParent: self)
        */
        
        
        /*
        first.view.translatesAutoresizingMaskIntoConstraints = false
        second.view.translatesAutoresizingMaskIntoConstraints = false
        */
        //self.view.addSubview(firstStackView)
        let firstStackView = UIStackView(arrangedSubviews: [second.view])
        firstStackView.backgroundColor = .red
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addChild(second)
        second.view.translatesAutoresizingMaskIntoConstraints = false
        //firstStackView.addSubview(second.view)
        second.didMove(toParent: self)
        
        firstStackView.axis = .vertical
        firstStackView.alignment = .fill
        firstStackView.distribution = .fillEqually
        firstStackView.spacing = 5
        self.view.addSubview(firstStackView)
        //firstStackView = UIStackView(arrangedSubviews: [first.view])
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            /*
            first.view.topAnchor.constraint(equalTo: margins.topAnchor),
            first.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            first.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            //first.view.bottomAnchor.constraint(equalTo: second.view.topAnchor),
            first.view.heightAnchor.constraint(equalToConstant: 200),
            
            second.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            second.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            second.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            second.view.heightAnchor.constraint(equalToConstant: 200)
            */
            firstStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            firstStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            firstStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            //first.view.bottomAnchor.constraint(equalTo: second.view.topAnchor),
            firstStackView.heightAnchor.constraint(equalToConstant: 200),
            
            
        ])
    }
}
