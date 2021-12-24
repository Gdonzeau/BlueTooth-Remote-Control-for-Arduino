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
    
    var saveTitle = UILabel()
    
    var connectButton = UIButton() // Press this button to connect to BT
    var disconnectButton = UIButton() // Press this button to disconnect from BT
    var activityIndicator = UIActivityIndicatorView()
    //var btNames: [String] = []
    //var nameBTModule = UITableView()
    
    var mainView = MainView()
    var infosButtons = InfoButtons()
    
    let tableOfProfiles = UITableView()
    let tableBluetooth = UITableView()
    
    var profiles : [Profile] = []
    var profileLoaded = Profile(name: "", datas: "")
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
    var peripheralsDetected = [PeripheralDetected]()
    
    var test = "Test passé"
    
    var status:Status = .disconnected {
        didSet {
            resetViewState()
            switch status {
            case .connecting:
                activityIndicator.startAnimating()
                connectButton.isHidden = true
                disconnectButton.isHidden = true
                tableBluetooth.isHidden = true
            case .error:
                let error = AppError.loadingError
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            case .disconnected:
                activityIndicator.stopAnimating()
                connectButton.isHidden = false
                disconnectButton.isHidden = true
                tableBluetooth.isHidden = false
            case .connected:
                activityIndicator.stopAnimating()
                connectButton.isHidden = true
                disconnectButton.isHidden = false
                tableBluetooth.isHidden = true
            }
        }
    }
    private func resetViewState() {
        mainView.connection.activityIndicator.stopAnimating()
        mainView.connection.connect.isHidden = true
        mainView.connection.disconnect.isHidden = true
        tableBluetooth.isHidden = false
    }
    // End of Bluetooth part
    
    var autoadjust = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = .disconnected
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        //   setConstraints()
        
        let idTry = UUID().uuidString
        print("ID : \(idTry)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //overrideUserInterfaceStyle = .dark
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
        // Setting Title
        saveTitle.backgroundColor = appColors.backgroundColor
        saveTitle.contentMode = .scaleAspectFit
        saveTitle.textAlignment = .center
        saveTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        saveTitle.translatesAutoresizingMaskIntoConstraints = false
        
        //tableBluetooth.backgroundColor = .black
        tableBluetooth.layer.cornerRadius = 24
        tableBluetooth.layer.masksToBounds = true
        
        tableBluetooth.translatesAutoresizingMaskIntoConstraints = false
        
        connectButton.layer.cornerRadius = 24
        connectButton.layer.masksToBounds = true
        connectButton.setTitle("Connect", for: .normal)
        connectButton.backgroundColor = appColors.buttonColor
        //connectButton.tintColor = .black
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        disconnectButton.layer.cornerRadius = 24
        disconnectButton.layer.masksToBounds = true
        disconnectButton.setTitle("Disconnect", for: .normal)
        disconnectButton.backgroundColor = appColors.buttonColor
        //disconnectButton.tintColor = .black
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        
        connectButton.contentMode = .scaleAspectFit
        disconnectButton.contentMode = .scaleAspectFit
        
        disconnectButton.addTarget(self, action: #selector(disconnect), for: .touchUpInside)
        
        connectButton.addTarget(self, action: #selector(connect), for: .touchUpInside)
        
        // Buttons and datas in "mainView"
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        //Button Load / TableView with profiles available
        loadButton.backgroundColor = appColors.buttonColor
        loadButton.layer.cornerRadius = 24
        loadButton.layer.masksToBounds = true
        loadButton.setTitle("Load Profile", for: .normal)
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.addTarget(self, action: #selector(loadProfile), for: .touchUpInside)
        
        tableOfProfiles.layer.cornerRadius = 24
        tableOfProfiles.layer.masksToBounds = true
        view.addSubview(tableOfProfiles)
        tableOfProfiles.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Constraints
        
        let margins = view.layoutMarginsGuide
        // Title
        let titleStackView = UIStackView(arrangedSubviews: [saveTitle])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .fill
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 5
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleStackView)
        
        //connectionModule
        let connectionStackView = UIStackView(arrangedSubviews: [tableBluetooth,connectButton,disconnectButton,activityIndicator])
        connectionStackView.axis = .horizontal
        connectionStackView.alignment = .fill
        connectionStackView.distribution = .fill
        connectionStackView.spacing = 5
        connectionStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStackView)
        
        // Mainview already configurated
        
        //
        let loadButtonProfileTVStackView = UIStackView(arrangedSubviews: [tableOfProfiles,loadButton])
        loadButtonProfileTVStackView.axis = .horizontal
        loadButtonProfileTVStackView.alignment = .fill
        //sixthStackView.distribution = .fill
        loadButtonProfileTVStackView.spacing = 5
        loadButtonProfileTVStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadButtonProfileTVStackView)
        
        //GlobalStackView
        let globalStackView = UIStackView(arrangedSubviews: [titleStackView,connectionStackView,mainView,loadButtonProfileTVStackView])
        globalStackView.axis = .vertical
        globalStackView.alignment = .fill
        globalStackView.spacing = 5
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        globalStackView.addArrangedSubview(titleStackView)
        globalStackView.addArrangedSubview(connectionStackView)
        globalStackView.addArrangedSubview(mainView)
        globalStackView.addArrangedSubview(loadButtonProfileTVStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            
            connectButton.widthAnchor.constraint(equalTo: connectionStackView.heightAnchor, multiplier: 20/9),
            connectionStackView.heightAnchor.constraint(equalToConstant: 60),
            loadButtonProfileTVStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    func setupTableView() {
        tableOfProfiles.register(UITableViewCell.self,forCellReuseIdentifier: "cell_Profile")
        tableOfProfiles.dataSource = self
        tableOfProfiles.delegate = self
        
        tableBluetooth.register(UITableViewCell.self, forCellReuseIdentifier: "cell_ModuleBT")
        tableBluetooth.dataSource = self
        tableBluetooth.delegate = self
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
            
            saveTitle.text = dataBase.name
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
            buttons[index].isEnabled = true
            
            if infosButtons.name[index] == "" && infosButtons.order[index] == "" {
                infosButtons.notSeen[index] = true
            } else {
                infosButtons.notSeen[index] = false
            }
            
            if infosButtons.notSeen[index] == true {
                
                if autoadjust == true {
                    buttons[index].isHidden = true
                } else {
                    buttons[index].isEnabled = false
                    buttons[index].backgroundColor = appColors.buttonNotEnableColor
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
            overrideUserInterfaceStyle = .dark
            //AlternateTableLoadButton(tableShown: false)
            
            //window.overrideUserInterfaceStyle = .dark
        }
        
        if buttonTag == 5 {
            overrideUserInterfaceStyle = .light
            //AlternateTableLoadButton(tableShown: true)
        }
        if buttonTag == 6 {
            
            /*
            // To edit profile in use
            let navVC = tabBarController?.viewControllers![1] as! UINavigationController
                    let configurationVC = navVC.topViewController as! ConfigurationViewController
            configurationVC.test = test
            configurationVC.profileReceivedToBeLoaded = profileLoaded
            
            tabBarController?.selectedIndex = 1
 */
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

extension UIApplication {
    /*function will return reference to tabbarcontroller */
    func tabbarController() -> UIViewController? {
        guard let vcs = self.keyWindow?.rootViewController?.children else { return nil }
        
        for vc in vcs {
            if  let _ = vc as? TabBarViewController {
                return vc
            }
        }
        return nil
    }
}
