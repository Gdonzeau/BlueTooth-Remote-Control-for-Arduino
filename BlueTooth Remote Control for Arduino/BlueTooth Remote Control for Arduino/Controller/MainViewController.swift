//
//  ViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    let appColors = AppColors.shared
    var mainView = MainView()
    let infosButtons = InfoButtons()
    let tableOfSaves = TableViewController()
    //var bottomContainer = UIStackView()
    // Test insertion
    
    var controller = PickerViewBluetoothAvailableViewController()
    var autoadjust = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinateActions()
        setupView()
     //   setConstraints()
    }
    
    func setupView() {
        view.backgroundColor = appColors.backgroundColor
        
        view.addSubview(mainView)
        //view.addSubview(bottomContainer)
        //addChild(tableOfSaves)
        let bottomContainer = UIStackView(arrangedSubviews: [tableOfSaves.view])
        //addChild(tableOfSaves)
        //view.addSubview(tableOfSaves.view)
        //tableOfSaves.didMove(toParent: self)
        tableOfSaves.view.contentMode = .scaleAspectFit
        
        bottomContainer.axis = .vertical
        bottomContainer.alignment = .fill
        bottomContainer.distribution = .fillEqually
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addArrangedSubview(tableOfSaves.view)
        view.addSubview(bottomContainer)
        tableOfSaves.view.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //verticalStackView.rankButtons01.remoteButton02.isHidden = true
        /*
    }
    
    func setConstraints() {
        */
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            mainView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: margins.topAnchor),
            
            
            /*
            tableOfSaves.view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            tableOfSaves.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableOfSaves.view.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            tableOfSaves.view.heightAnchor.constraint(equalToConstant: 200),
 */
            
            bottomContainer.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            //bottomContainer.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 160),
            
            tableOfSaves.view.heightAnchor.constraint(equalToConstant: 160),
            tableOfSaves.view.topAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
            tableOfSaves.view.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            tableOfSaves.view.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor)
            
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
        tableOfSaves.willMove(toParent: nil)
        tableOfSaves.removeFromParent()
        tableOfSaves.view.removeFromSuperview()
        }
        if title == "05" {
          //  bottomContainer.addSubview(tableOfSaves.view)
          //  addChild(tableOfSaves)
            tableOfSaves.didMove(toParent: self)
            setupView()
          //  setConstraints()
        }
    }
    
    
}

