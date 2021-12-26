//
//  RemoteViewController_BlueTooth.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//
import CoreBluetooth
import UIKit

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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let nameTarget = peripheral.name {
            let peripheralDetected = PeripheralDetected(name: nameTarget, peripheral: peripheral, indentifier: peripheral.identifier)
            peripheralsDetected.append(peripheralDetected)
            bluetoothAvailableTableView.reloadData()
        }
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Erreur de connection")
    }
    
    
    func connectBT(peripheral: CBPeripheral) {
        status = .connecting
        targetPeripheral = peripheral
        targetPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(targetPeripheral)
        status = .connected
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        status = .connected
        targetPeripheral.discoverServices([targetCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral) {
        
        status = .disconnected
    }
}

extension RemoteViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
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
            
            if let result = String( data: characteristic.value! , encoding: .utf8) {
                receivedMessage(messageReceived: result)
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}
