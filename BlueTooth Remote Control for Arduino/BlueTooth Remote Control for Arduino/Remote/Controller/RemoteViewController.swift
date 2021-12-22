//
//  ViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit
import CoreData
import CoreBluetooth

class RemoteViewController: UIViewController {
    let appColors = AppColors.shared
    let profileStorageManager = ProfileStorageManager.shared
    
    var mainView = MainView()
    var infosButtons = InfoButtons()
    
    let tableOfProfiles = UITableView()
    let tableBluetooth = UITableView()
    
    var profiles : [Profile] = []
    //var profilesName: [String] = []
    let loadButton = UIButton()
    
    // BlueTooth part
    let targetCBUUID = CBUUID(string: "0xFFE0")
    let dialogCBUUID = CBUUID(string: "FFE1")
    
    var centralManager: CBCentralManager!
    var targetPeripheral: CBPeripheral!
    var targetPeripheral02: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var peripherals = [CBPeripheral]()
    var peripheralsName = [String]()
    var peripheralsDetected = [PeripheralsDetected]()
    
    //var status: Status = .disconnected
    
    //var code = ["1255000000","1000255000","LED_ON","LED_OFF","1193000255","1000255255"]
    
    var nom01 = ""
    
    var status:Status = .disconnected {
        didSet {
            resetViewState()
            switch status {
            case .connecting:
                mainView.connection.activityIndicator.startAnimating()
                mainView.connection.connect.isHidden = true
                mainView.connection.disconnect.isHidden = true
                mainView.connection.nameBTModule.isHidden = true
            case .error:
                let error = AppError.loadingError
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            case .disconnected:
                mainView.connection.activityIndicator.stopAnimating()
                mainView.connection.connect.isHidden = false
                mainView.connection.disconnect.isHidden = true
                mainView.connection.nameBTModule.isHidden = false
            case .connected:
                mainView.connection.activityIndicator.stopAnimating()
                mainView.connection.connect.isHidden = true
                mainView.connection.disconnect.isHidden = false
                mainView.connection.nameBTModule.isHidden = true
            }
        }
    }
    private func resetViewState() {
        mainView.connection.activityIndicator.stopAnimating()
        mainView.connection.connect.isHidden = true
        mainView.connection.disconnect.isHidden = true
        mainView.connection.nameBTModule.isHidden = false
    }
    // End of Bluetooth part
    
    var autoadjust = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = .disconnected
        centralManager = CBCentralManager(delegate: self, queue: nil)
        mainView.connection.nameBTModule = tableBluetooth
        
        
        //   setConstraints()
        
        let idTry = UUID().uuidString
        print("ID : \(idTry)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        getProfilesFromDatabase()
        
        AlternateTableLoadButton(tableShown: false)
        //updatingTableView()
        setupTableView()

    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    func setupView() {
        view.backgroundColor = appColors.backgroundColor
        
        loadButton.backgroundColor = appColors.buttonColor
        loadButton.layer.cornerRadius = 4
        loadButton.layer.masksToBounds = true
        loadButton.setTitle("Load Profile", for: .normal)
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.addTarget(self, action: #selector(loadProfile), for: .touchUpInside)
        
        mainView.connection.disconnect.addTarget(self, action: #selector(disconnect), for: .touchUpInside)
        
        mainView.connection.connect.addTarget(self, action: #selector(connect), for: .touchUpInside)
        
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableOfProfiles)
        tableOfProfiles.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [tableOfProfiles,loadButton])
        
        
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        //sixthStackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
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
            
            stackView.topAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor),
            //stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    func setupTableView() {
        tableOfProfiles.register(UITableViewCell.self,forCellReuseIdentifier: "cell_Profile")
        tableOfProfiles.dataSource = self
        tableOfProfiles.delegate = self
        
        tableBluetooth.register(UITableViewCell.self, forCellReuseIdentifier: "cell_ModuleBT")
        tableBluetooth.dataSource = self
        tableBluetooth.dataSource = self
    }
    
    func updatingTableView() {
        /*
        profilesName = []
        for profile in profiles {
            profilesName.append(profile.name)
        }
 */
    }
    
    func configurationButtons(rank:Int) {
        
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
            
            let dataBase = profiles[rank]
            
            mainView.title.title.text = dataBase.name
            let datasArray = dataBase.datas.components(separatedBy: ":")
            print("Array : \(datasArray)")
            
            for index in 0 ..< infosButtons.name.count {
                infosButtons.name[index] = datasArray[index]
                infosButtons.order[index] = datasArray[index+9]
            }
            
            mainView.datas.titleData01.text = datasArray[18]
            mainView.datas.titleData02.text = datasArray[19]
            
            print("\(infosButtons.order)")
            print("\(infosButtons.name)")
            
        }
        
        for index in 0 ... 8 {
            buttons[index].tag = index
            buttons[index].addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttons[index].setTitle(infosButtons.name[index], for: .normal)
            if infosButtons.name[index] == "" && infosButtons.order[index] == "" {
                infosButtons.notSeen[index] = true
            } else {
                infosButtons.notSeen[index] = false
            }
            
            if infosButtons.notSeen[index] == true {
                
                if autoadjust == true {
                    buttons[index].isHidden = true
                } else {
                    buttons[index].backgroundColor = appColors.backgroundColor
                    buttons[index].setTitleColor(appColors.backgroundColor, for: .normal)
                }
            } else {
                buttons[index].isHidden = false
                buttons[index].backgroundColor = appColors.buttonColor
                buttons[index].setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let buttonTag = sender.tag
        
        print(buttonTag)
        print(infosButtons.order[sender.tag])
        print("Le bouton \(infosButtons.name[sender.tag]) a été pressé.")
        let order = infosButtons.order[buttonTag]
        if buttonTag == 4 {
            AlternateTableLoadButton(tableShown: false)
        }
        
        if buttonTag == 5 {
            AlternateTableLoadButton(tableShown: true)
        }
        sendOrder(message: order)
    }
    @objc func connect() {
        if peripheralsDetected.count > 0 {
        status = .connecting
       let peripheral = peripheralsDetected[0].peripheral
        connectBT(peripheral: peripheral)
        } else {
            print("No bluetooth detected")
        }
    }
    
    @objc func disconnect() {
        status = .disconnected
        guard let peripheral = targetPeripheral else {
            return
        }
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func getProfilesFromDatabase() {
        do {
            profiles = try profileStorageManager.loadProfiles()
            if profiles.isEmpty {
                print("Vide")
                //viewState = .empty
            } else {
                for profile in profiles {
                    print("\(profile.name)")
                }
            }
        } catch let error {
            print("Error loading recipes from database \(error.localizedDescription)")
        }
    }
    
    func AlternateTableLoadButton(tableShown: Bool) {
        loadButton.isHidden = tableShown
        tableOfProfiles.isHidden = !tableShown
        
    }
    
    @objc func loadProfile() {
        AlternateTableLoadButton(tableShown: true)
    }
    
    func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
}

