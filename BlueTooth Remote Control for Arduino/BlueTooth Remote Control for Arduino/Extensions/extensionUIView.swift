//
//  extensionUIView.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume on 08/07/2023.
//

import Foundation
import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}
