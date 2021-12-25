//
//  VerticalStackView.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 13/12/2021.
//

import UIKit

class MainView: UIStackView {
    var appColors = AppColors.shared
    let title = Title()
    let rankButtons01 = ThreeButtonsLine()
    let rankButtons02 = ThreeButtonsLine()
    let rankButtons03 = ThreeButtonsLine() 
    let connection = Connection()
    let datas = DatasReceived()
    let bouton = ButtonForConfiguration()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //title.title.text = "Titre"
        
        backgroundColor = appColors.backgroundColor
        alignment = .fill
        axis = .vertical
        distribution = .fillProportionally
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 5
        
        //addArrangedSubview(title)
        //addArrangedSubview(connection)
        addArrangedSubview(rankButtons01)
        addArrangedSubview(rankButtons02)
        addArrangedSubview(rankButtons03)
        addArrangedSubview(datas)
        
    }
}

