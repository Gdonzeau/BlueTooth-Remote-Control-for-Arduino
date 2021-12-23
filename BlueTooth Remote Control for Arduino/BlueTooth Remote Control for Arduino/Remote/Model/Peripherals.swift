//
//  Peripheral.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 20/12/2021.
//

import Foundation
import CoreBluetooth

struct PeripheralDetected {
    var name: String
    var peripheral: CBPeripheral
    var indentifier: UUID
}
