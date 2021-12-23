//
//  Colors.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 17/12/2021.
//

import UIKit

class AppColors {// Enum et static let
    static let shared = AppColors()
    let backgroundColor = UIColor(displayP3Red: 7/255, green: 171/255, blue: 128/255, alpha: 1)
    let buttonColor = UIColor.darkGray
    let buttonNotEnableColor = UIColor(displayP3Red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    let selectedButtonColor = UIColor.red
    let fontColor = UIColor.darkGray
}

