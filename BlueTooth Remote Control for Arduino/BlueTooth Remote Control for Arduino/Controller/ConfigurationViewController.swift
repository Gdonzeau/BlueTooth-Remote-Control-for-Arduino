//
//  ConfigurationViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class ConfigurationViewController: UIViewController {
    //let first = FirstChildViewController()
    //var firstStackView = UIStackView()
    //let secondStackView = UIStackView()
    //let finalStackView = UIStackView()
    //let second = PickerViewBluetoothAvailableViewController()
    //let second = SecondChildViewController()
    let appColors = AppColors.shared
    let second = TableViewController()
    let configView = ConfigView()
    var buttons = [UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton(),UIButton()]
    var infosButtons = InfoButtons()
    
    override func viewDidLoad() {
        //tryWithTableView()
        setView()
        setConstraints()
        configuration()
    }
    
    func setView() {
        view.backgroundColor = appColors.backgroundColor
        view.addSubview(configView)
        configView.translatesAutoresizingMaskIntoConstraints = false
        configView.nameButtons01.orderForButton01.placeholder = "Button's name"
        configView.nameButtons01.orderForButton02.placeholder = "Button's name"
        configView.nameButtons01.orderForButton03.placeholder = "Button's name"
        configView.nameButtons02.orderForButton01.placeholder = "Button's name"
        configView.nameButtons02.orderForButton02.placeholder = "Button's name"
        configView.nameButtons02.orderForButton03.placeholder = "Button's name"
        configView.nameButtons03.orderForButton01.placeholder = "Button's name"
        configView.nameButtons03.orderForButton02.placeholder = "Button's name"
        configView.nameButtons03.orderForButton03.placeholder = "Button's name"

    }
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            configView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            configView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            configView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            configView.topAnchor.constraint(equalTo: margins.topAnchor),
            
            configView.rankButtons01.remoteButton01.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons01.remoteButton02.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons01.remoteButton03.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons02.remoteButton01.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons02.remoteButton02.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons02.remoteButton03.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons03.remoteButton01.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons03.remoteButton02.heightAnchor.constraint(equalToConstant: 40),
            configView.rankButtons03.remoteButton03.heightAnchor.constraint(equalToConstant: 40),

            
            ])
            
    }
    
    func configuration() {
        
        buttons = [configView.rankButtons01.remoteButton01,
                       configView.rankButtons01.remoteButton02,
                       configView.rankButtons01.remoteButton03,
                       configView.rankButtons02.remoteButton01,
                       configView.rankButtons02.remoteButton02,
                       configView.rankButtons02.remoteButton03,
                       configView.rankButtons03.remoteButton01,
                       configView.rankButtons03.remoteButton02,
                       configView.rankButtons03.remoteButton03]
        
        for index in 0 ..< buttons.count {
            buttons[index].tag = index + 1
        }
        
        for button in buttons {
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
    }
    
    func setting() {
        for index in 0 ..< buttons.count {
            if infosButtons.order[index] == "" {
                infosButtons.notSeen[index] = true
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        initializeButtons()
        sender.backgroundColor = appColors.selectedButtonColor
    }
    
    func initializeButtons() {
        /*
        let buttons = [configView.rankButtons01.remoteButton01,
                       configView.rankButtons01.remoteButton02,
                       configView.rankButtons01.remoteButton03,
                       configView.rankButtons02.remoteButton01,
                       configView.rankButtons02.remoteButton02,
                       configView.rankButtons02.remoteButton03,
                       configView.rankButtons03.remoteButton01,
                       configView.rankButtons03.remoteButton02,
                       configView.rankButtons03.remoteButton03]
        */
        for button in buttons {
            button.backgroundColor = appColors.buttonColor
        }
        
    }
    
    func tryWithTableView() {
        view.backgroundColor = .lightGray
        super.viewDidLoad()
        
        let firstStackView = UIStackView(arrangedSubviews: [second.view])
        firstStackView.backgroundColor = .red
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addChild(second)
        second.didMove(toParent: self)
        
        firstStackView.axis = .vertical
        firstStackView.alignment = .fill
        firstStackView.distribution = .fillEqually
        firstStackView.spacing = 5
        self.view.addSubview(firstStackView)
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            firstStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            firstStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            firstStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            firstStackView.heightAnchor.constraint(equalToConstant: 216),
            
            second.view.topAnchor.constraint(equalTo: margins.topAnchor),
            second.view.bottomAnchor.constraint(equalTo: firstStackView.bottomAnchor),
            second.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            second.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            
            
            
        ])
    }
}
