//
//  InstructionsViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 17/12/2021.
//

import UIKit

class InstructionsViewController: UIViewController, UITextFieldDelegate {
    
    let appColors = AppColors.shared
    var boutonTest = ButtonForConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ok")
        setupView()
    }
    
    func setupView() {
        boutonTest.nameTextField.delegate = self
        boutonTest.orderTextField.delegate = self
        
        view.backgroundColor = appColors.backgroundColor
        view.addSubview(boutonTest)
        boutonTest.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            boutonTest.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            boutonTest.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            boutonTest.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            boutonTest.topAnchor.constraint(equalTo: margins.topAnchor),
        ])
    }
    
}
