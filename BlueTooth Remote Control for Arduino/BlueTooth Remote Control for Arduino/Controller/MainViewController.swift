//
//  ViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class MainViewController: UIViewController {
    var verticalStackView = VerticalStackView()
    let infosButtons = InfoButtons()
    let secondView = UIViewController()
    let saves = TableViewController()
    // Test insertion
    
    var controller = PickerViewBluetoothAvailableViewController()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(saves)
        self.view.addSubview(saves.view)
        saves.didMove(toParent: self)
        saves.view.translatesAutoresizingMaskIntoConstraints = false
        
        coordinateActions()
        setupView()
        setConstraints()
    }
    
    func setupView() {
        self.view.addSubview(verticalStackView)
        
    }
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            saves.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            saves.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            saves.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            saves.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    func coordinateActions() {
        let buttons = [verticalStackView.rankButtons01.remoteButton01,
                       verticalStackView.rankButtons01.remoteButton02,
                       verticalStackView.rankButtons01.remoteButton03,
                       verticalStackView.rankButtons02.remoteButton01,
                       verticalStackView.rankButtons02.remoteButton02,
                       verticalStackView.rankButtons02.remoteButton03,
                       verticalStackView.rankButtons03.remoteButton01,
                       verticalStackView.rankButtons03.remoteButton02,
                       verticalStackView.rankButtons03.remoteButton03]
        
        for index in 0 ... 8 {
            buttons[index].tag = index
            buttons[index].addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttons[index].setTitle(infosButtons.name[index], for: .normal)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        guard let title = sender.currentTitle else {
            return
        }
        
        print(title)
        print(infosButtons.order[sender.tag])
        print("Le bouton \(infosButtons.name[sender.tag]) a été pressé.")
        saves.dismiss(animated: true)
    }
}

