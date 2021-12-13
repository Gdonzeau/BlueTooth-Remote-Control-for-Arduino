//
//  ViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class MainViewController: UIViewController {
    var verticalStackView = VerticalStackView()
    let orders = Orders()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //overrideUserInterfaceStyle = .dark
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
            //verticalStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1.5)
            verticalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        ])
        
    }
    
    func coordinateActions() {
        verticalStackView.rankButtons01.remoteButton01.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons01.remoteButton02.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons01.remoteButton03.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons02.remoteButton01.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons02.remoteButton02.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons02.remoteButton03.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons03.remoteButton01.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons03.remoteButton02.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        verticalStackView.rankButtons03.remoteButton03.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        verticalStackView.rankButtons01.remoteButton01.tag = 0
        verticalStackView.rankButtons01.remoteButton02.tag = 1
        verticalStackView.rankButtons01.remoteButton03.tag = 2
        verticalStackView.rankButtons02.remoteButton01.tag = 3
        verticalStackView.rankButtons02.remoteButton02.tag = 4
        verticalStackView.rankButtons02.remoteButton03.tag = 5
        verticalStackView.rankButtons03.remoteButton01.tag = 6
        verticalStackView.rankButtons03.remoteButton02.tag = 7
        verticalStackView.rankButtons03.remoteButton03.tag = 8
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        guard let title = sender.currentTitle else {
            return
        }
        print(title)
        print(orders.array[sender.tag])
    }
}

