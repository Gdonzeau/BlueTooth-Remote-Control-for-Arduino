//
//  PickerViewBluetoothAvailableViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 14/12/2021.
//

import UIKit

class PickerViewBluetoothAvailableViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let dataArray = ["English", "Maths", "History", "German", "Science"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let UIPicker: UIPickerView = UIPickerView()
        UIPicker.delegate = self as UIPickerViewDelegate
        UIPicker.dataSource = self as UIPickerViewDataSource
        self.view.addSubview(UIPicker)
        UIPicker.center = self.view.center
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = dataArray[row]
        return row
    }
}

