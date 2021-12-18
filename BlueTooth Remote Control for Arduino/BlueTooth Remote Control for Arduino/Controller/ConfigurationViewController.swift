//
//  ConfigurationViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class ConfigurationViewController: UIViewController, UITextViewDelegate {
    
    let appColors = AppColors.shared
    let profileStorageManager = ProfileStorageManager.shared
    
    var infosButtons = InfoButtons()
    let buttonsForConfiguration = [ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration()]
    var nameProfile = UITextField()
    var dataName01 = UITextField()
    var dataName02 = UITextField()
    var line = UIView()
    var dataProfile = [String]()
    let saveButton = UIButton()
    
    override func viewDidLoad() {
        //tryWithTableView()
        setup()
        setView()
        setConstraints()
        configuration()
    }
    func setup() {
        for index in 0 ..< buttonsForConfiguration.count {
            buttonsForConfiguration[index].nameTextField.delegate = self
            buttonsForConfiguration[index].orderTextField.delegate = self
        }
        
        
        nameProfile.delegate = self
        dataName02.delegate = self
        dataName01.delegate = self
    }
    
    func setView() {
        
        saveButton.backgroundColor = appColors.buttonColor
        saveButton.setTitle("Save", for: .normal)
        saveButton.contentMode = .scaleAspectFit
        saveButton.layer.cornerRadius = 4
        saveButton.layer.masksToBounds = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 60) //???
        saveButton.widthAnchor.constraint(equalToConstant: 60)
        
        view.backgroundColor = appColors.backgroundColor
        line.backgroundColor = .green
        dataName01.backgroundColor = .white
        dataName01.placeholder = "First data's name"
        dataName02.backgroundColor = .white
        dataName02.placeholder = "Second data's name"
        nameProfile.backgroundColor = .white
        nameProfile.placeholder = "Save's name"
        
        
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        
        let firstStackView = UIStackView(arrangedSubviews: [buttonsForConfiguration[0],buttonsForConfiguration[1],buttonsForConfiguration[2]])
        firstStackView.axis = .horizontal
        firstStackView.alignment = .fill
        firstStackView.distribution = .fillEqually
        firstStackView.spacing = 2
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.addArrangedSubview(buttonsForConfiguration[0])
        firstStackView.addArrangedSubview(buttonsForConfiguration[1])
        firstStackView.addArrangedSubview(buttonsForConfiguration[2])
        view.addSubview(firstStackView)
        
        let secondStackView = UIStackView(arrangedSubviews: [buttonsForConfiguration[3],buttonsForConfiguration[4],buttonsForConfiguration[5]])
        secondStackView.axis = .horizontal
        secondStackView.alignment = .fill
        secondStackView.distribution = .fillEqually
        secondStackView.spacing = 2
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.addArrangedSubview(buttonsForConfiguration[3])
        secondStackView.addArrangedSubview(buttonsForConfiguration[4])
        secondStackView.addArrangedSubview(buttonsForConfiguration[5])
        view.addSubview(secondStackView)
        
        let thirdStackView = UIStackView(arrangedSubviews: [buttonsForConfiguration[6],buttonsForConfiguration[7],buttonsForConfiguration[8]])
        thirdStackView.axis = .horizontal
        thirdStackView.alignment = .fill
        thirdStackView.distribution = .fillEqually
        thirdStackView.spacing = 2
        thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView.addArrangedSubview(buttonsForConfiguration[6])
        thirdStackView.addArrangedSubview(buttonsForConfiguration[7])
        thirdStackView.addArrangedSubview(buttonsForConfiguration[8])
        view.addSubview(thirdStackView)
        
        let fourthStackView = UIStackView(arrangedSubviews: [line])
        line.layer.cornerRadius = 4
        line.layer.masksToBounds = true
        
        fourthStackView.axis = .horizontal
        fourthStackView.alignment = .fill
        fourthStackView.distribution = .fillEqually
        fourthStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fourthStackView)
        
        let fithStackView = UIStackView(arrangedSubviews: [dataName01,dataName02])
        dataName01.layer.cornerRadius = 2
        dataName01.layer.masksToBounds = true
        dataName02.layer.cornerRadius = 4
        dataName02.layer.masksToBounds = true
        fithStackView.axis = .horizontal
        fithStackView.alignment = .fill
        fithStackView.distribution = .fillEqually
        fithStackView.spacing = 5
        fithStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fithStackView)
        
        let sixthStackView = UIStackView(arrangedSubviews: [nameProfile,saveButton])
        nameProfile.layer.cornerRadius = 2
        nameProfile.layer.masksToBounds = true
        
        
        sixthStackView.axis = .horizontal
        sixthStackView.alignment = .fill
        //sixthStackView.distribution = .fill
        sixthStackView.spacing = 5
        sixthStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sixthStackView)
        
        let globalStackView = UIStackView(arrangedSubviews: [firstStackView,secondStackView,thirdStackView])
        globalStackView.axis = .vertical
        globalStackView.alignment = .fill
        globalStackView.distribution = .fillProportionally
        globalStackView.spacing = 5
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        globalStackView.addArrangedSubview(firstStackView)
        globalStackView.addArrangedSubview(secondStackView)
        globalStackView.addArrangedSubview(thirdStackView)
        globalStackView.addArrangedSubview(fourthStackView)
        globalStackView.addArrangedSubview(fithStackView)
        globalStackView.addArrangedSubview(sixthStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            
            fourthStackView.heightAnchor.constraint(equalToConstant: 10),
            fithStackView.heightAnchor.constraint(equalToConstant: 30),
            sixthStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configuration() {
        for index in 0 ..< buttonsForConfiguration.count {
            buttonsForConfiguration[index].tag = index + 1
            buttonsForConfiguration[index].button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    func setting() {
        for index in 0 ..< buttonsForConfiguration.count {
            if infosButtons.order[index] == "" {
                infosButtons.notSeen[index] = true
            }
        }
    }
    
    func updateButtons() {
        for index in 0 ..< buttonsForConfiguration.count {
            let name = buttonsForConfiguration[index].nameTextField.text
            //let order = buttonsForConfiguration[index].orderTextField.text
            
            buttonsForConfiguration[index].button.setTitle(name, for: .normal)
            buttonsForConfiguration[index].nameTextField.text = ""
            
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        initializeButtons()
        sender.backgroundColor = appColors.selectedButtonColor
        resigningFirstResponder()
    }
    
    @objc func save(sender: UIButton!) {
        groupDatasInArray()
        var profilePreparedToSave: Profile? {
            didSet {
                if let nameToSave = nameProfile.text {
                    profilePreparedToSave?.name = nameToSave
                }
                
                profilePreparedToSave?.datas = dataProfile
            }
        }
        guard let profileToSave = profilePreparedToSave else {
            return
        }
        do {
            try profileStorageManager.saveProfile(profile: profileToSave)
        } catch {
            print("Error while saving")
            /*
             let error = AppError.errorSaving
             if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
             allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
             }
             */
        }
    }
    
    func groupDatasInArray() {
        //dataProfile.append(nameProfile.text ?? "Save")
        dataProfile.append(dataName01.text ?? "Data01")
        dataProfile.append(dataName02.text ?? "Data02")
        
        for button in buttonsForConfiguration {
            dataProfile.append(button.nameTextField.text ?? "_")
            dataProfile.append(button.orderTextField.text ?? "_")
        }
    }
    
    func initializeButtons() {
        for index in 0 ..< buttonsForConfiguration.count {
            buttonsForConfiguration[index].button.backgroundColor = appColors.buttonColor
        }
        
    }
    func resigningFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
    }
}

extension ConfigurationViewController: UITextFieldDelegate { // To dismiss keyboard when returnKey
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
        
        updateButtons()
        return true
    }
}
