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
    private let profileStorageManager = ProfileStorageManager.shared
    
    var mainView = MainView()
    var infosButtons = InfoButtons()
    let tableOfProfiles = UITableView()
    var profiles : [Profile] = []
    var profilesName: [String] = []
    let loadButton = UIButton()
    
    // BlueTooth part
    let targetCBUUID = CBUUID(string: "0xFFE0")
    let dialogCBUUID = CBUUID(string: "FFE1")
    
    var centralManager: CBCentralManager!
    var targetPeripheral: CBPeripheral!
    var targetPeripheral02: CBPeripheral!
    var writeCharacteristic: CBCharacteristic!
    var peripheralsName = [String]()
    
    var connected = false
    var code = ["1255000000","1000255000","LED_ON","LED_OFF","1193000255","1000255255"]
    
    var nom01 = ""
    // End of Bluetooth part
    
    var autoadjust = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        //configurationButtons(rank:0)
        //   setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        tableOfProfiles.reloadData()
        getProfilesFromDatabase()
 */
        setupView()
        getProfilesFromDatabase()
        // Test pour TableView
        tableOfProfiles.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableOfProfiles.dataSource = self
        tableOfProfiles.delegate = self
        
        AlternateTableLoadButton(tableShown: false)
        updatingTableView()
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
            /*
            tableOfProfiles.topAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor),
            tableOfProfiles.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            tableOfProfiles.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableOfProfiles.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
 */
            stackView.topAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor),
            //stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    func setupTableView() {
        tableOfProfiles.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updatingTableView() {
        profilesName = []
        for profile in profiles {
            profilesName.append(profile.name)
        }
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
            
            infosButtons.name[0] = datasArray[0]
            infosButtons.order[0] = datasArray[1]
            infosButtons.name[1] = datasArray[2]
            infosButtons.order[1] = datasArray[3]
            infosButtons.name[2] = datasArray[4]
            infosButtons.order[2] = datasArray[5]
            infosButtons.name[3] = datasArray[6]
            infosButtons.order[3] = datasArray[7]
            infosButtons.name[4] = datasArray[8]
            infosButtons.order[4] = datasArray[9]
            infosButtons.name[5] = datasArray[10]
            infosButtons.order[5] = datasArray[11]
            infosButtons.name[6] = datasArray[12]
            infosButtons.order[6] = datasArray[13]
            infosButtons.name[7] = datasArray[14]
            infosButtons.order[7] = datasArray[15]
            infosButtons.name[8] = datasArray[16]
            infosButtons.order[8] = datasArray[17]
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
        
        if buttonTag == 4 {
            AlternateTableLoadButton(tableShown: false)
        }
        
        if buttonTag == 5 {
            AlternateTableLoadButton(tableShown: true)
        }
    }
    
    private func getProfilesFromDatabase() {
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
    
    private func AlternateTableLoadButton(tableShown: Bool) {
        loadButton.isHidden = tableShown
        tableOfProfiles.isHidden = !tableShown
        
    }
    
    @objc private func loadProfile() {
        AlternateTableLoadButton(tableShown: true)
    }
    
    private func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
    
}
extension RemoteViewController: UITableViewDataSource {
    
    // func numberOfSection not necessary as 1 by default
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0//Choose your custom row height
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touch \(indexPath.row)")
        configurationButtons(rank:indexPath.row)
        AlternateTableLoadButton(tableShown:false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     cell.textLabel?.text = profilesName[indexPath.row]
     return cell
     }
     */
}

extension RemoteViewController: UITableViewDelegate {
    /*
    private func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) throws -> UISwipeActionsConfiguration? { // Swipe action
        /*
        guard recipeMode == .database else {
            return nil
        }
        */
        let deleteAction = UIContextualAction(
            style: .destructive, title: "Delete") { _, _, completionHandler in
            let profileToDelete = self.profiles[indexPath.row]
            
            do {
                try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                DispatchQueue.main.async {
                    self.getProfilesFromDatabase()
                }
                completionHandler(true)
            } catch {
                print("Error while deleting")
                completionHandler(false)
                let error = AppError.errorDelete
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let deleteAction = UIContextualAction(
                style: .destructive, title: "Delete") { _, _, completionHandler in
                let profileToDelete = self.profiles[indexPath.row]
                
                do {
                    try self.profileStorageManager.deleteProfile(profileToDelete: profileToDelete)
                    DispatchQueue.main.async {
                        self.getProfilesFromDatabase()
                    }
                    completionHandler(true)
                } catch {
                    print("Error while deleting")
                    completionHandler(false)
                    let error = AppError.errorDelete
                    if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                        self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                    }
                }
            }
            
            profilesName.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
        if editingStyle == .insert {
        }
    }
}


extension RemoteViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [targetCBUUID])
        default:
            print("Oh ben zut alors.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        if let nameTarget = peripheral.name {
            print("Le périphérique s'appelle : \(nameTarget)")
            peripheralsName.append(nameTarget)
            nom01 = String(nameTarget)
        }
       // if nom01.starts(with: "BT") || nom01.starts(with: "HM") || nom01.starts(with: "GD") || nom01.starts(with: "new")  {
        targetPeripheral = peripheral
        targetPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(targetPeripheral)
        //}
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        connected = true
        targetPeripheral.discoverServices([targetCBUUID])
     //   targetPeripheral02.discoverServices([targetCBUUID])
    }
    func sendOrder (message:String) {
        if connected {
            let dataA = message.data(using: .utf8)
            targetPeripheral.writeValue(dataA!, for: writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
}

extension RemoteViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Trouvé !")
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            for characteristic in service.characteristics!{
                let aCharacteristic = characteristic as CBCharacteristic
                if aCharacteristic.uuid == CBUUID(string: "FFE1"){
                    print("We found our write Characteristic")
                    writeCharacteristic = aCharacteristic
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case dialogCBUUID:
            print("Test")
            print(characteristic.value ?? "no value")
            if let result = String( data: characteristic.value! , encoding: .utf8) {
                print("Reçu : \(result)")
                // On sépare le String aux : pour faire un tableau
                let resultArr = result.components(separatedBy: ":")
                if resultArr.count > 1 {
                let data01 = "\(resultArr[1])"
                let data02 = "\(resultArr[0])"
                    mainView.datas.contentData01.text = data01
                    mainView.datas.contentData02.text = data02
                }
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}
