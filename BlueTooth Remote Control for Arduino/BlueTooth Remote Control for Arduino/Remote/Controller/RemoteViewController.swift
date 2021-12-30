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
    
    let profileStorageManager = ProfileStorageManager.shared
    
    private var saveTitle = UILabel()
    
    private var actualizeButton = UIButton() // Press this button to connect to BT
    private var disconnectButton = UIButton() // Press this button to disconnect from BT
    private var activityIndicator = UIActivityIndicatorView()
    
    private var firstThreeButtons = ThreeButtonsLine()
    private var secondThreeButtons = ThreeButtonsLine()
    private var thirdThreeButtons = ThreeButtonsLine()
    
    private var titleData01 = UILabel()
    private var contentData01 = UILabel()
    private var titleData02 = UILabel()
    private var contentData02 = UILabel()
    
    private var infosButtons = InfoButtons() // Contains names, order, seen or not
    
    let profilesTableView = UITableView()
    let bluetoothAvailableTableView = UITableView()
    
    var profiles : [Profile] = []
    var profileLoaded = Profile(name: "", datas: "")
    
    private let loadButton = UIButton() // Button to show the tableView with profiles
    
    private var autoadjust = false // Buttons not used will be hidden or just enabled
    
    // BlueTooth part
    let targetCBUUID = CBUUID(string: "0xFFE0")
    let dialogCBUUID = CBUUID(string: "FFE1")
    
    var centralManager: CBCentralManager!
    var targetPeripheral: CBPeripheral!
    var targetPeripheral02: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var peripherals = [CBPeripheral]()
    var peripheralsDetected = [PeripheralDetected]()
    
    private var heightSVConnected:CGFloat = 60.0
    private var heightSVLoadProfile:CGFloat = 60.0
    
    // MARK: - Status
    
    var status:Status = .disconnected {
        didSet {
            resetViewState()
            switch status {
            
            case .connecting:
                activityIndicator.startAnimating()
                actualizeButton.isHidden = true
                disconnectButton.isHidden = true
                bluetoothAvailableTableView.isHidden = true
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
                bluetoothAvailableTableView.isHidden = false
                heightSVConnected = 120.0
                setupView()
                
            case .connected:
                activityIndicator.stopAnimating()
                actualizeButton.isHidden = true
                disconnectButton.isHidden = false
                bluetoothAvailableTableView.isHidden = true
                heightSVConnected = 60.0
                setupView()
            }
        }
    }
    
    // End of Bluetooth part
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status = .disconnected
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        getProfilesFromDatabase()
        AlternateTableLoadButton(tableShown: false)
        setupTableView()
        
    }
    
    override func loadView() {
        super.loadView()
        titleData01.text = "Data01 :"
        titleData02.text = "Data02 :"
        
    }
    
    // MARK: - SetupView
    
    private func setupView() {
        //UIFont.preferredFont(forTextStyle: UIFont.systemFont(ofSize: 20.0)) ???
        view.backgroundColor = AppColors.backgroundColorArduino
        // Setting Title
        saveTitle.adjustsFontForContentSizeCategory = true
        saveTitle.backgroundColor = AppColors.backgroundColorArduino
        saveTitle.contentMode = .scaleAspectFit
        saveTitle.textAlignment = .center
        saveTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        saveTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Connection Module
        bluetoothAvailableTableView.layer.cornerRadius = 24
        bluetoothAvailableTableView.layer.masksToBounds = true
        bluetoothAvailableTableView.translatesAutoresizingMaskIntoConstraints = false
        
        actualizeButton.layer.cornerRadius = 24
        actualizeButton.layer.masksToBounds = true
        actualizeButton.setTitle("Actualize", for: .normal)
        actualizeButton.backgroundColor = AppColors.buttonColor
        actualizeButton.contentMode = .scaleAspectFit
        actualizeButton.translatesAutoresizingMaskIntoConstraints = false
        actualizeButton.addTarget(self, action: #selector(actualize), for: .touchUpInside)

        disconnectButton.layer.cornerRadius = 24
        disconnectButton.layer.masksToBounds = true
        disconnectButton.setTitle("Disconnect", for: .normal)
        disconnectButton.backgroundColor = AppColors.buttonColor
        disconnectButton.contentMode = .scaleAspectFit
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        disconnectButton.addTarget(self, action: #selector(disconnect), for: .touchUpInside)
        
        // Datas received from Arduino
        titleData01.adjustsFontForContentSizeCategory = true
        titleData01.contentMode = .scaleAspectFit

        contentData01.adjustsFontForContentSizeCategory = true
        contentData01.text = ""
        contentData01.contentMode = .scaleAspectFit

        titleData02.adjustsFontForContentSizeCategory = true
        titleData02.contentMode = .scaleAspectFit

        contentData02.adjustsFontForContentSizeCategory = true
        contentData02.text = ""
        contentData02.contentMode = .scaleAspectFit

        
        //Button Load / TableView with profiles available
        loadButton.backgroundColor = AppColors.buttonColor
        loadButton.layer.cornerRadius = 24
        loadButton.layer.masksToBounds = true
        loadButton.setTitle("Load Profile", for: .normal)
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.addTarget(self, action: #selector(loadProfile), for: .touchUpInside)
        
        profilesTableView.layer.cornerRadius = 24
        profilesTableView.layer.masksToBounds = true
        profilesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilesTableView)
        
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
        let connectionStackView = UIStackView(arrangedSubviews: [bluetoothAvailableTableView,actualizeButton,disconnectButton,activityIndicator])
        connectionStackView.axis = .horizontal
        connectionStackView.alignment = .fill
        connectionStackView.distribution = .fill
        connectionStackView.spacing = 5
        connectionStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStackView)
        
        // Nine buttons Stackview
        let buttonsStackView = UIStackView(arrangedSubviews: [firstThreeButtons,secondThreeButtons,thirdThreeButtons])
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 5
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        // Stackview with datas received from Arduino
        let dataReceivedStackView = UIStackView(arrangedSubviews: [titleData01,contentData01,titleData02,contentData02])
        dataReceivedStackView.axis = .horizontal
        dataReceivedStackView.alignment = .fill
        dataReceivedStackView.distribution = .fillEqually
        dataReceivedStackView.spacing = 5
        dataReceivedStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataReceivedStackView)
        
        // Stackview with alternatively loadButton and TableView with profiles
        let loadButtonProfileTVStackView = UIStackView(arrangedSubviews: [profilesTableView,loadButton])
        loadButtonProfileTVStackView.axis = .horizontal
        loadButtonProfileTVStackView.alignment = .fill
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
        globalStackView.addArrangedSubview(loadButtonProfileTVStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            globalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor,constant: -40),
            
            titleStackView.heightAnchor.constraint(equalToConstant: 32.0),
            actualizeButton.widthAnchor.constraint(equalTo: connectionStackView.heightAnchor, multiplier: 1/1),
            connectionStackView.heightAnchor.constraint(equalToConstant: heightSVConnected),
            loadButtonProfileTVStackView.heightAnchor.constraint(equalToConstant: heightSVLoadProfile)
        ])
        
    }
    
    // MARK: - TableViews
    
    private func setupTableView() {
        profilesTableView.register(UITableViewCell.self,forCellReuseIdentifier: "cell_Profile")
        profilesTableView.dataSource = self
        profilesTableView.delegate = self
        
        bluetoothAvailableTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_ModuleBT")
        bluetoothAvailableTableView.dataSource = self
        bluetoothAvailableTableView.delegate = self
    }
    
    // MARK: - Buttons Configuration
    
    func configurationButtons(rank:Int) { // To configure buttons and datas from profile selected
        
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
            
            for index in 0 ..< infosButtons.name.count {
                infosButtons.name[index] = datasArray[index]
                infosButtons.order[index] = datasArray[index+9]
            }
            titleData01.text = datasArray[18]
            titleData02.text = datasArray[19]
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
                    buttons[index].backgroundColor = AppColors.buttonNotEnableColor
                    //buttons[index].setTitleColor(appColors.backgroundColor, for: .normal)
                }
            } else {
                buttons[index].isHidden = false
                buttons[index].backgroundColor = AppColors.buttonColor
                buttons[index].setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton) {
        
        let buttonTag = sender.tag
        let order = infosButtons.order[buttonTag]
        sendOrder(message: order)
    }
    
    @objc func actualize() {
        peripheralsDetected = []
        bluetoothAvailableTableView.reloadData()
        centralManager.scanForPeripherals(withServices: [targetCBUUID])
    }
    
    @objc func disconnect() {
        status = .disconnected
        guard let peripheral = targetPeripheral else {
            return
        }
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    @objc func loadProfile() {
        AlternateTableLoadButton(tableShown: true)
    }
    
    func getProfilesFromDatabase() {
        do {
            profiles = try profileStorageManager.loadProfiles()
            
            profilesTableView.reloadData()
        } catch let error {
            print("Error loading recipes from database \(error.localizedDescription)")
        }
    }
    
    func AlternateTableLoadButton(tableShown: Bool) {
        loadButton.isHidden = tableShown
        profilesTableView.isHidden = !tableShown
        
        if tableShown == true {
            heightSVLoadProfile = 120
        } else {
            heightSVLoadProfile = 60
        }
        setupView()
        
    }
    
    private func resetViewState() {
        activityIndicator.stopAnimating()
        actualizeButton.isHidden = true
        disconnectButton.isHidden = true
        bluetoothAvailableTableView.isHidden = false
        heightSVConnected = 120.0
    }
    
    // MARK: - Communication Bluetooth
    
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
                guard targetPeripheral.state != .disconnected else {
                    
                    let error = AppError.peripheralDisconnected
                    if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                        allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                    }
                    status = .disconnected
                    actualize()
                    return
                }
                /*
                guard let writeCharacteristicToUse = writeCharacteristic else {
                    return
                }
                */
                targetPeripheral?.writeValue(dataA, for: writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
    
    // MARK: - Errors
    
    func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
