//
//  VerticalStackView.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 13/12/2021.
//

import UIKit

class VerticalStackView: UIStackView {
    
    let rankButtons01 = HorizontalViewWithButtons()
    let rankButtons02 = HorizontalViewWithButtons()
    let rankButtons03 = HorizontalViewWithButtons()
    let connection = Connection()
    let datas = DatasReceived()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        alignment = .fill
        axis = .vertical
        distribution = .fill
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 5
        
        addArrangedSubview(connection)
        addArrangedSubview(rankButtons01)
        addArrangedSubview(rankButtons02)
        addArrangedSubview(rankButtons03)
        addArrangedSubview(datas)
        
    }
}
