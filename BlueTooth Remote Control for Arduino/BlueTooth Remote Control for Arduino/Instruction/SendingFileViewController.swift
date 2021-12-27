//
//  SendingFileViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 27/12/2021.
//

import UIKit

class SendingFileViewController: UIViewController {

    
    //let file = Arduino.zip
    let url = NSURL.fileURLWithPath(Arduino.zip)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    let sendPhoto = UIActivityViewController(activityItems: , applicationActivities: nil)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
