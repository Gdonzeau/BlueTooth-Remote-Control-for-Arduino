//
//  ViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit
import CoreData

class RemoteViewController: UIViewController {
    let appColors = AppColors.shared
    private let profileStorageManager = ProfileStorageManager.shared
    
    var mainView = MainView()
    let infosButtons = InfoButtons()
    let tableOfProfiles = UITableView()
    let tableOfSaves = TableViewController()
    var profiles : [Profile] = []
    var profilesName: [String] = ["01","02","03"]
    
    
    //var bottomContainer = UIStackView()
    // Test insertion
    
    var controller = PickerViewBluetoothAvailableViewController()
    var autoadjust = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationButtons()
        setupView()
        getProfilessFromDatabase()
        for profile in profiles {
            profilesName.append(profile.name)
        }
        tableOfSaves.myArray = profilesName
        
        setupTableView()
     //   setConstraints()
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    func setupView() {
        view.backgroundColor = appColors.backgroundColor
        
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableOfProfiles)
        tableOfProfiles.translatesAutoresizingMaskIntoConstraints = false
        
        /*
        let bottomContainer = UIStackView(arrangedSubviews: [tableOfSaves.view])
        
        tableOfSaves.view.contentMode = .scaleAspectFit
        tableOfSaves.view.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainer.axis = .vertical
        bottomContainer.alignment = .fill
        bottomContainer.distribution = .fillEqually
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addArrangedSubview(tableOfSaves.view)
        view.addSubview(bottomContainer)
        */
        
        
        
        
        //verticalStackView.rankButtons01.remoteButton02.isHidden = true
        /*
    }
    
    func setConstraints() {
        */
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: margins.topAnchor),
            mainView.bottomAnchor.constraint(lessThanOrEqualTo: tableOfProfiles.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            
            tableOfProfiles.topAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor),
            tableOfProfiles.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            tableOfProfiles.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableOfProfiles.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            /*
            bottomContainer.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 160),
            
            tableOfSaves.view.heightAnchor.constraint(equalToConstant: 160),
            tableOfSaves.view.topAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
            tableOfSaves.view.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            tableOfSaves.view.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor)
            */
        ])
        
    }
    
    func setupTableView() {
        tableOfProfiles.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func configurationButtons() {
        
        let buttons = [mainView.rankButtons01.remoteButton01,
                       mainView.rankButtons01.remoteButton02,
                       mainView.rankButtons01.remoteButton03,
                       mainView.rankButtons02.remoteButton01,
                       mainView.rankButtons02.remoteButton02,
                       mainView.rankButtons02.remoteButton03,
                       mainView.rankButtons03.remoteButton01,
                       mainView.rankButtons03.remoteButton02,
                       mainView.rankButtons03.remoteButton03]
        
        if profiles.count > 0 {
        let dataBase = profiles[0]
            mainView.title.title.text = dataBase.name
            let datasArray = dataBase.datas.components(separatedBy: ":")
            
            if datasArray.count > 1 {
                buttons[0].setTitle(datasArray[0], for: .normal)
            }
        }
        
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
            tableOfProfiles.isHidden = true
            /*
        tableOfSaves.willMove(toParent: nil)
        tableOfSaves.removeFromParent()
        tableOfSaves.view.removeFromSuperview()
 */
        }
        
        if title == "05" {
            tableOfProfiles.isHidden = false
            /*
        tableOfSaves.didMove(toParent: self)
        setupView()
 */
        }
    }
    
    private func getProfilessFromDatabase() {
        do {
            profiles = try profileStorageManager.loadProfiles()
            if profiles.isEmpty {
                print("Vide")
                //viewState = .empty
            } else {
                for profile in profiles {
                print("\(profile.name)")
                }
                //viewState = .showData
                
            }
        } catch let error {
            print("Error loading recipes from database \(error.localizedDescription)")
            //viewState = .error
        }
    }
    
    private func configureButtons() {
        
        
    }
    
}
extension RemoteViewController: UITableViewDataSource {
    
    // func numberOfSection not necessary as 1 by default
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(profilesName[indexPath.row])"
        return cell
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as IndexPath)
        
        cell.textLabel!.text = "\(profiles[indexPath.row])"
        return cell
        */
    }
    
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profilesName[indexPath.row]
        return cell
      }
    */
}
