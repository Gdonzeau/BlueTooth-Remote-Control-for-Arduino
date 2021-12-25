//
//  RemoteViewController_BlueTooth.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//
import CoreBluetooth

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
            mainView.connection.btNames = []
            centralManager.scanForPeripherals(withServices: [targetCBUUID])
        default:
            print("Oh ben zut alors.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print(peripheral)
        //peripheralsDetected = []
        if let nameTarget = peripheral.name {
            // À retirer par la suite
            print("Le périphérique s'appelle : \(nameTarget)")
            let peripheralDetected = PeripheralDetected(name: nameTarget, peripheral: peripheral, indentifier: peripheral.identifier)
            /*
            for peripheralRegistred in peripheralsDetected {
                
                guard peripheralRegistred.indentifier != peripheralDetected.indentifier else {
                    return
                }
                peripheralsDetected.append(peripheralDetected)
                tableBluetooth.reloadData()
            }
            */
            peripheralsDetected.append(peripheralDetected)
            tableBluetooth.reloadData()
            peripheralsName.append(nameTarget)
            //nom01 = nameTarget
            //
            // Gestion des périphériques BlueTooth détectés
            
            /*
            peripheralsDetected.append(peripheralDetected)
            tableBluetooth.reloadData()
 */            
            //mainView.connection.btNames.append(nameTarget)
            //mainView.connection.nameBTModule.reloadData()
        }
        
    }
    func connectBT(peripheral: CBPeripheral) {
        status = .connecting
       // if nom01.starts(with: "BT") || nom01.starts(with: "HM") || nom01.starts(with: "GD") || nom01.starts(with: "new")  {
        targetPeripheral = peripheral
        targetPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(targetPeripheral)
        status = .connected
        //}
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        status = .connected
        targetPeripheral.discoverServices([targetCBUUID])
     //   targetPeripheral02.discoverServices([targetCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral) {
        print("Disconnected !")
        status = .disconnected
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
                receivedMessage(messageReceived: result)
            }
           /*
                // On sépare le String aux : pour faire un tableau
                let resultArr = result.components(separatedBy: ":")
                if resultArr.count > 1 {
                let data01 = "\(resultArr[0])"
                let data02 = "\(resultArr[1])"
                    mainView.datas.contentData01.text = data01
                    mainView.datas.contentData02.text = data02
                }
            }
        */
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}
