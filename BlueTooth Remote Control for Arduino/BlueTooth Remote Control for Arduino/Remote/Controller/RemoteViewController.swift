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
    
    var actualizeButton = UIButton() // Press this button to connect to BT
    var disconnectButton = UIButton() // Press this button to disconnect from BT
    var activityIndicator = UIActivityIndicatorView()
    //var btNames: [String] = []
    //var nameBTModule = UITableView()
    
    var mainView = MainView()
    var firstThreeButtons = ThreeButtonsLine()
    var secondThreeButtons = ThreeButtonsLine()
    var thirdThreeButtons = ThreeButtonsLine()
    
    var titleData01 = UILabel()
    var contentData01 = UILabel()
    var titleData02 = UILabel()
    var contentData02 = UILabel()
    
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
    
    var heightSVConnected:CGFloat = 60.0
    var heightSVLoadProfile:CGFloat = 60.0
    
    var status:Status = .disconnected {
        didSet {
            resetViewState()
            switch status {
            
            case .connecting:
                activityIndicator.startAnimating()
                actualizeButton.isHidden = true
                disconnectButton.isHidden = true
                tableBluetooth.isHidden = true
                heightSVConnected = 60.0
                setupView()
                
            case .error:
                
                
                let error = AppError.loadingError
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
                
            case .disconnected:
                activityIndicator.stopAnimating()
                actualizeButton.isHidden = false
                disconnectButton.isHidden = true
                tableBluetooth.isHidden = false
                heightSVConnected = 120.0
                setupView()
                
            case .connected:
                activityIndicator.stopAnimating()
                actualizeButton.isHidden = true
                disconnectButton.isHidden = false
                tableBluetooth.isHidden = true
                heightSVConnected = 60.0
                setupView()
            }
        }
    }
    private func resetViewState() {
        mainView.connection.activityIndicator.stopAnimating()
        mainView.connection.connect.isHidden = true
        mainView.connection.disconnect.isHidden = true
        tableBluetooth.isHidden = false
        heightSVConnected = 120.0
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
        //UIFont.preferredFont(forTextStyle: UIFont.systemFont(ofSize: 20.0))
        view.backgroundColor = appColors.backgroundColor
        // Setting Title
        saveTitle.adjustsFontForContentSizeCategory = true
        saveTitle.backgroundColor = appColors.backgroundColor
        saveTitle.contentMode = .scaleAspectFit
        saveTitle.textAlignment = .center
        saveTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        saveTitle.translatesAutoresizingMaskIntoConstraints = false
        
        tableBluetooth.layer.cornerRadius = 24
        tableBluetooth.layer.masksToBounds = true
        tableBluetooth.translatesAutoresizingMaskIntoConstraints = false

        actualizeButton.layer.cornerRadius = 24
        actualizeButton.layer.masksToBounds = true
        actualizeButton.setTitle("Actualize", for: .normal)
        actualizeButton.backgroundColor = appColors.buttonColor
        actualizeButton.translatesAutoresizingMaskIntoConstraints = false
        
        disconnectButton.layer.cornerRadius = 24
        disconnectButton.layer.masksToBounds = true
        disconnectButton.setTitle("Disconnect", for: .normal)
        disconnectButton.backgroundColor = appColors.buttonColor
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        
        actualizeButton.contentMode = .scaleAspectFit
        disconnectButton.contentMode = .scaleAspectFit
        
        disconnectButton.addTarget(self, action: #selector(disconnect), for: .touchUpInside)
        
        actualizeButton.addTarget(self, action: #selector(actualize), for: .touchUpInside)
        
        // Buttons and datas in "mainView"
        //view.addSubview(mainView)
        //mainView.translatesAutoresizingMaskIntoConstraints = false
        titleData01.adjustsFontForContentSizeCategory = true
        titleData02.adjustsFontForContentSizeCategory = true
        contentData01.adjustsFontForContentSizeCategory = true
        contentData02.adjustsFontForContentSizeCategory = true
        
        titleData01.text = "Data01 :"
        titleData02.text = "Data02 :"
        contentData01.text = ""
        contentData02.text = ""
        
        titleData01.contentMode = .scaleAspectFit
        contentData01.contentMode = .scaleAspectFit
        titleData02.contentMode = .scaleAspectFit
        contentData02.contentMode = .scaleAspectFit
        
        
        
        
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
        let connectionStackView = UIStackView(arrangedSubviews: [tableBluetooth,actualizeButton,disconnectButton,activityIndicator])
        connectionStackView.axis = .horizontal
        connectionStackView.alignment = .fill
        connectionStackView.distribution = .fill
        connectionStackView.spacing = 5
        connectionStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStackView)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [firstThreeButtons,secondThreeButtons,thirdThreeButtons])
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 5
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        let dataReceivedStackView = UIStackView(arrangedSubviews: [titleData01,contentData01,titleData02,contentData02])
        dataReceivedStackView.axis = .horizontal
        dataReceivedStackView.alignment = .fill
        dataReceivedStackView.distribution = .fillEqually
        dataReceivedStackView.spacing = 5
        dataReceivedStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataReceivedStackView)
        
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
        let globalStackView = UIStackView(arrangedSubviews: [titleStackView,connectionStackView,buttonsStackView,dataReceivedStackView,loadButtonProfileTVStackView])
        globalStackView.axis = .vertical
        globalStackView.alignment = .fill
        globalStackView.spacing = 5
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        globalStackView.addArrangedSubview(titleStackView)
        globalStackView.addArrangedSubview(connectionStackView)
        globalStackView.addArrangedSubview(buttonsStackView)
        globalStackView.addArrangedSubview(dataReceivedStackView)
        //globalStackView.addArrangedSubview(mainView)
        globalStackView.addArrangedSubview(loadButtonProfileTVStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            //globalStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            //globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            globalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor,constant: -40),
            
            titleStackView.heightAnchor.constraint(equalToConstant: 32.0),
            //actualizeButton.heightAnchor.constraint(equalToConstant: 32.0),
            //actualizeButton.widthAnchor.constraint(equalTo: connectionStackView.heightAnchor, multiplier: 20/9),
            connectionStackView.heightAnchor.constraint(equalToConstant: heightSVConnected),
            loadButtonProfileTVStackView.heightAnchor.constraint(equalToConstant: heightSVLoadProfile)
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
        
        let buttons = [firstThreeButtons.remoteButton01,
                       firstThreeButtons.remoteButton02,
                       firstThreeButtons.remoteButton03,
                       secondThreeButtons.remoteButton01,
                       secondThreeButtons.remoteButton02,
                       secondThreeButtons.remoteButton03,
                       thirdThreeButtons.remoteButton01,
                       thirdThreeButtons.remoteButton02,
                       thirdThreeButtons.remoteButton03]
        
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
                    //buttons[index].backgroundColor = appColors.backgroundColor
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
            //view.window?.overrideUserInterfaceStyle = .dark
            
        }
        
        if buttonTag == 5 {
            //view.window?.overrideUserInterfaceStyle = .light
            
        }
        if buttonTag == 6 {
            
        }
        sendOrder(message: order)
    }
    @objc func actualize() {
        peripheralsDetected = []
        tableBluetooth.reloadData()
        centralManager.scanForPeripherals(withServices: [targetCBUUID])
        /*
        if peripheralsDetected.count > 0 {
            status = .connecting
            let peripheral = peripheralsDetected[0].peripheral
            connectBT(peripheral: peripheral)
        } else {
            print("No bluetooth detected")
        }
 */
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
        
        if tableShown == true {
            heightSVLoadProfile = 120
        } else {
            heightSVLoadProfile = 60
        }
        setupView()
        
    }
    
    @objc func loadProfile() {
        AlternateTableLoadButton(tableShown: true)
    }
    
    func receivedMessage(messageReceived: String) {
        // On sépare le String aux : pour faire un tableau
        let messageReceivedInArray = messageReceived.components(separatedBy: ":")
        if messageReceivedInArray.count > 1 {
        let data01 = "\(messageReceivedInArray[0])"
        let data02 = "\(messageReceivedInArray[1])"
            contentData01.text = data01
            contentData02.text = data02
        }
    }
    
    func sendOrder (message:String) {
        if status == .connected {
            if let dataA = message.data(using: .utf8) {
            targetPeripheral.writeValue(dataA, for: writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
        }
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
