//
//  ConfigurationActionKeyboardViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 22/12/2021.
//

import UIKit

extension ConfigurationViewController: UITextFieldDelegate { // To dismiss keyboard when returnKey
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
        
        updateButtons()
        return true
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dataName01 || textField == dataName02 || textField == nameProfile {
            animateViewMoving(up: true, moveValue: 120)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == dataName01 || textField == dataName02 || textField == nameProfile {
            animateViewMoving(up: false, moveValue: 120)
        }
    }

    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)

        //UIView.beginAnimations("animateView", context: nil)
        UIView.animate(withDuration: movementDuration, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        })
        /*
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)

        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        
        UIView.commitAnimations()
        */
    }
}

