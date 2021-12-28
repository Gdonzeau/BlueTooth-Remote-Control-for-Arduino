//
//  SendingFileViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 27/12/2021.
//

import UIKit

class SendingFileViewController: UIViewController {
        
    let imageButton = UIButton()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
}

extension SendingFileViewController {
    
     func setup() {
        
        titleLabel.text = "Files"
        subtitleLabel.text = "Select document to download :"
        imageButton.addTarget(self, action: #selector(gettingFile), for: .touchUpInside)
        imageButton.tag = 0
        view.backgroundColor = AppColors.backgroundColorArduino
        titleLabel.tintColor = .systemGray6
        subtitleLabel.tintColor = .systemGray6
    }
    
    private func style() {
        
        imageButton.setImage(UIImage(named: "FileArduino"), for: .normal)
        imageButton.setTitle(" Arduino : Led and Servo", for: .normal)
        imageButton.layer.cornerRadius = 24
        imageButton.layer.masksToBounds = true
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.contentMode = .scaleAspectFit
        imageButton.backgroundColor = AppColors.buttonColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.contentMode = .scaleAspectFit
        titleLabel.textAlignment = .center
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        subtitleLabel.textAlignment = .justified
        
        subtitleLabel.numberOfLines = 0
    }
        
    private func layout() {
        let margins = view.layoutMarginsGuide
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .fill
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 5
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleStackView)
        
        let subtitleStackView = UIStackView(arrangedSubviews: [subtitleLabel])
        subtitleStackView.axis = .horizontal
        subtitleStackView.alignment = .fill
        subtitleStackView.distribution = .fillEqually
        subtitleStackView.spacing = 5
        subtitleStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleStackView)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [imageButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 5
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        let globalStackView = UIStackView(arrangedSubviews: [titleStackView,subtitleStackView,buttonsStackView])
        globalStackView.axis = .vertical
        globalStackView.alignment = .fill
        globalStackView.spacing = 5
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        globalStackView.addArrangedSubview(titleStackView)
        globalStackView.addArrangedSubview(subtitleStackView)
        globalStackView.addArrangedSubview(buttonsStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            
            titleStackView.heightAnchor.constraint(equalToConstant: 32.0),
            subtitleStackView.heightAnchor.constraint(equalToConstant: 50),
            imageButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func gettingFile(sender: UIButton) {
        
        var filesToShare = [Any]()

        if let fileURL = Bundle.main.url(forResource: FilesInformations.name[sender.tag], withExtension: FilesInformations.withEnd[sender.tag]) {
            print("found")
            filesToShare.append(fileURL)
            shareTapped(files: filesToShare)
        }
    }
    
    @objc func shareTapped(files: [Any]) {
        let vc = UIActivityViewController(activityItems: files, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
