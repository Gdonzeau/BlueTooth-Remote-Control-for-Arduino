//
//  ViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class MainViewController: UIViewController {
    let appColors = AppColors.shared
    var mainView = MainView()
    let infosButtons = InfoButtons()
    let secondView = UIViewController()
    let saves = TableViewController()
    var bottomContainer = UIStackView()
    // Test insertion
    
    var controller = PickerViewBluetoothAvailableViewController()
    var autoadjust = true
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinateActions()
        setupView()
        setConstraints()
    }
    
    func setupView() {
        view.backgroundColor = appColors.backgroundColor
        self.view.addSubview(mainView)
        self.view.addSubview(bottomContainer)
        addChild(saves)
        bottomContainer = UIStackView(arrangedSubviews: [saves.view])
        self.addChild(saves)
        self.view.addSubview(saves.view)
        saves.didMove(toParent: self)
        saves.view.contentMode = .scaleAspectFit
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.alignment = .fill
        bottomContainer.distribution = .fillEqually
        saves.view.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //verticalStackView.rankButtons01.remoteButton02.isHidden = true
        
    }
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            mainView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            //verticalStackView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: margins.topAnchor),
            
            saves.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            saves.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            saves.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            saves.view.heightAnchor.constraint(equalToConstant: 200)
 
            /*
            bottomContainer.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
            */
        ])
        
    }
    
    func coordinateActions() {
        
        let buttons = [mainView.rankButtons01.remoteButton01,
                       mainView.rankButtons01.remoteButton02,
                       mainView.rankButtons01.remoteButton03,
                       mainView.rankButtons02.remoteButton01,
                       mainView.rankButtons02.remoteButton02,
                       mainView.rankButtons02.remoteButton03,
                       mainView.rankButtons03.remoteButton01,
                       mainView.rankButtons03.remoteButton02,
                       mainView.rankButtons03.remoteButton03]
        
        for index in 0 ... 8 {
            buttons[index].tag = index
            buttons[index].addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttons[index].setTitle(infosButtons.name[index], for: .normal)
            if infosButtons.notSeen[index] == true {
                if autoadjust == true {
                buttons[index].isHidden = true
                } else {
                    buttons[index].backgroundColor = super.view.backgroundColor
                    buttons[index].tintColor = super.view.backgroundColor
                }
            } else {
                buttons[index].isHidden = false
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        guard let title = sender.currentTitle else {
            return
        }
        
        print(title)
        print(infosButtons.order[sender.tag])
        print("Le bouton \(infosButtons.name[sender.tag]) a été pressé.")
        if title == "04" {
        saves.willMove(toParent: nil)
        saves.removeFromParent()
        saves.view.removeFromSuperview()
        }
        if title == "05" {
            bottomContainer.addSubview(saves.view)
            addChild(saves)
            saves.didMove(toParent: self)
            setupView()
            setConstraints()
        }
    }
}

