//
//  ConfigurationViewController.swift
//  BlueTooth Remote Control for Arduino
//
//  Created by Guillaume Donzeau on 12/12/2021.
//

import UIKit

class ConfigurationViewController: UIViewController, UITextViewDelegate {
    
    //let appColors = AppColors.shared
    
    let profileStorageManager = ProfileStorageManager.shared
    
    var infosButtons = InfoButtons()
    let buttonsForConfiguration = [ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration(),ButtonForConfiguration()]
    var nameProfile = UITextField()
    var dataName01 = UITextField()
    var dataName02 = UITextField()
    var line = UIView()
    
    let saveButton = UIButton()
    let activityIndicator = UIActivityIndicatorView()
    
    var timer = Timer()
    //var profileSaving = Profile(name: "", datas:"")
    var profileReceivedToBeLoaded = Profile(name: "", datas: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setView()
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if profileReceivedToBeLoaded != Profile(name: "", datas: "") {
            loadingProfile(profileToLoad: profileReceivedToBeLoaded)
            profileReceivedToBeLoaded = Profile(name: "", datas: "")
        }
        
    }
    private func setup() {
        for index in 0 ..< buttonsForConfiguration.count {
            buttonsForConfiguration[index].nameTextField.delegate = self
            buttonsForConfiguration[index].orderTextField.delegate = self
        }
        nameProfile.delegate = self
        dataName02.delegate = self
        dataName01.delegate = self
    }
    
    // MARK: - Setup View
    
    private func setView() {
        
        view.backgroundColor = AppColors.backgroundColorArduino
        
        // 4 StackView = green line
        line.layer.cornerRadius = 4
        line.layer.masksToBounds = true
        line.backgroundColor = .green
        
        // 5 StackView = datasName
        dataName01.layer.cornerRadius = 4
        dataName01.layer.masksToBounds = true
        dataName01.backgroundColor = AppColors.backGroudTextField
        dataName01.placeholder = "First data's name"
        
        dataName02.layer.cornerRadius = 4
        dataName02.layer.masksToBounds = true
        dataName02.backgroundColor = AppColors.backGroudTextField
        dataName02.placeholder = "Second data's name"
        
        
        // 6 StackView = SaveName and Save button
        nameProfile.layer.cornerRadius = 2
        nameProfile.layer.masksToBounds = true
        nameProfile.placeholder = "Save's name"
        nameProfile.backgroundColor = AppColors.backGroudTextField
        
        saveButton.backgroundColor = AppColors.buttonColor
        saveButton.setTitle("Save", for: .normal)
        saveButton.contentMode = .scaleAspectFit
        saveButton.layer.cornerRadius = 4
        saveButton.layer.masksToBounds = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.stopAnimating()
    
    // MARK: - Constraints
    
        let margins = view.layoutMarginsGuide
        // First buttons line
        let firstRankButtonsStackView = UIStackView(arrangedSubviews: [buttonsForConfiguration[0],buttonsForConfiguration[1],buttonsForConfiguration[2]])
        firstRankButtonsStackView.axis = .horizontal
        firstRankButtonsStackView.alignment = .fill
        firstRankButtonsStackView.distribution = .fillEqually
        firstRankButtonsStackView.spacing = 2
        firstRankButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        firstRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[0])
        firstRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[1])
        firstRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[2])
        view.addSubview(firstRankButtonsStackView)
        
        // Second buttons line
        let secondRankButtonsStackView = UIStackView(arrangedSubviews: [buttonsForConfiguration[3],buttonsForConfiguration[4],buttonsForConfiguration[5]])
        secondRankButtonsStackView.axis = .horizontal
        secondRankButtonsStackView.alignment = .fill
        secondRankButtonsStackView.distribution = .fillEqually
        secondRankButtonsStackView.spacing = 2
        secondRankButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        secondRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[3])
        secondRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[4])
        secondRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[5])
        view.addSubview(secondRankButtonsStackView)
        
        // Third buttons line
        let thirdRankButtonsStackView = UIStackView(arrangedSubviews: [buttonsForConfiguration[6],buttonsForConfiguration[7],buttonsForConfiguration[8]])
        thirdRankButtonsStackView.axis = .horizontal
        thirdRankButtonsStackView.alignment = .fill
        thirdRankButtonsStackView.distribution = .fillEqually
        thirdRankButtonsStackView.spacing = 2
        thirdRankButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[6])
        thirdRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[7])
        thirdRankButtonsStackView.addArrangedSubview(buttonsForConfiguration[8])
        view.addSubview(thirdRankButtonsStackView)
        
        // Separator
        let separatorStackView = UIStackView(arrangedSubviews: [line])
        separatorStackView.axis = .horizontal
        separatorStackView.alignment = .fill
        separatorStackView.distribution = .fillEqually
        separatorStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorStackView)
        
        // Datas received from Arduino
        let datasReceivedStackView = UIStackView(arrangedSubviews: [dataName01,dataName02])
        datasReceivedStackView.axis = .horizontal
        datasReceivedStackView.alignment = .fill
        datasReceivedStackView.distribution = .fillEqually
        datasReceivedStackView.spacing = 5
        datasReceivedStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datasReceivedStackView)
        
        // Saving Profile Module
        let savingStackView = UIStackView(arrangedSubviews: [nameProfile,saveButton,activityIndicator])
        savingStackView.axis = .horizontal
        savingStackView.alignment = .fill
        savingStackView.spacing = 5
        savingStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(savingStackView)
        
        let globalStackView = UIStackView(arrangedSubviews: [firstRankButtonsStackView,secondRankButtonsStackView,thirdRankButtonsStackView])
        globalStackView.axis = .vertical
        globalStackView.alignment = .fill
        globalStackView.spacing = 5
        globalStackView.translatesAutoresizingMaskIntoConstraints = false
        globalStackView.addArrangedSubview(firstRankButtonsStackView)
        globalStackView.addArrangedSubview(secondRankButtonsStackView)
        globalStackView.addArrangedSubview(thirdRankButtonsStackView)
        globalStackView.addArrangedSubview(separatorStackView)
        globalStackView.addArrangedSubview(datasReceivedStackView)
        globalStackView.addArrangedSubview(savingStackView)
        view.addSubview(globalStackView)
        
        NSLayoutConstraint.activate([
            
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40),
            globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            
            separatorStackView.heightAnchor.constraint(equalToConstant: 10),
            datasReceivedStackView.heightAnchor.constraint(equalToConstant: 32),
            savingStackView.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalTo: savingStackView.heightAnchor, multiplier: 16/9),
        ])
    }
    
    
    
    private func configuration() {
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside) // action is assign to saveButton
    }
    /*
    func setting() { // If the button as no order to transmit, no need to see it
        for index in 0 ..< buttonsForConfiguration.count {
            if infosButtons.order[index] == "" {
                infosButtons.notSeen[index] = true
            }
        }
    }
    */
    func updateButtons() { // Button's name appear on the button
        for index in 0 ..< buttonsForConfiguration.count {
            let name = buttonsForConfiguration[index].nameTextField.text
            buttonsForConfiguration[index].button.setTitle(name, for: .normal)
        }
    }
    
    @objc func save(sender: UIButton) {
        var profileSaving = Profile(name: "", datas: "")
        
        for button in buttonsForConfiguration { // First of all, let's check there are no ":"
            
            if let buttonName = button.nameTextField.text, let buttonOrder = button.orderTextField.text, let data01 = dataName01.text, let data02 = dataName02.text {
                if buttonName.contains(":") || buttonOrder.contains(":") || data01.contains(":") || data02.contains(":") {
                    
                    let error = AppError.forbiddenCharacters
                    if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                        allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                    }
                    return
                }
            }
        }
        // Then let's check that save name doesn't exist already
        if let name = nameProfile.text {
            
            if name == "" {
                
                let error = AppError.nothingIsWritten
                if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                    allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                }
                return
            }
            
            // All is checked. Let's save the profile
            
            do {
                let profilesAlreadySaved = try profileStorageManager.loadProfiles()
                    for profile in profilesAlreadySaved {
                        if profile.name == name {
                            let error = AppError.nameAlreadyExists
                            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                                allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
                            }
                            return
                        }
                    }
            } catch let error {
                print("Error loading recipes from database \(error.localizedDescription)")
            }
            
            profileSaving.name = name
        }
        resigningFirstResponder()
        nameProfile.isHidden = true
        saveButton.isHidden = true
        activityIndicator.startAnimating()
        
        // Starting timer, for Your Eyes Only
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        
        profileSaving.datas = groupDatasInArray()
        
        do {
            try profileStorageManager.saveProfile(profile: profileSaving)
        } catch {
            print("Error while saving")
        }
    }
    
    @objc func fireTimer() {
        
        nameProfile.isHidden = false
        saveButton.isHidden = false
        activityIndicator.stopAnimating()
        timer.invalidate()
        initializeDatasButtons()
 
    }
    
    private func loadingProfile(profileToLoad: Profile) {
            nameProfile.text = profileToLoad.name
            let datasArray = profileToLoad.datas.components(separatedBy: ":")
            print("Array : \(datasArray)")
            
            for index in 0 ..< buttonsForConfiguration.count {
                buttonsForConfiguration[index].nameTextField.text = datasArray[index]
                buttonsForConfiguration[index].orderTextField.text = datasArray[index+9]
            }
        
        dataName01.text = datasArray[18]
        dataName02.text = datasArray[19]
            
            print("\(infosButtons.order)")
            print("\(infosButtons.name)")
    }
    
    private func groupDatasInArray() -> String {
        var dataProfile = ""
        var nameButtons = ""
        var orderButtons = ""
        for button in buttonsForConfiguration {
            let buttonName = button.nameTextField.text ?? "_"
            let buttonOrder = button.orderTextField.text ?? "_"
            
            nameButtons += buttonName + ":"
            orderButtons += buttonOrder + ":"
        }
        dataProfile += nameButtons + orderButtons
        let data01 = dataName01.text ?? " "
        let data02 = dataName02.text ?? " "
        dataProfile += data01 + ":" + data02
        return dataProfile
    }
    
    private func initializeDatasButtons() {
        for button in buttonsForConfiguration {
            button.nameTextField.text = ""
            button.orderTextField.text = ""
            button.button.setTitle("", for: .normal)
            dataName01.text = ""
            dataName02.text = ""
            nameProfile.text = ""
        }
    }
    
    func resigningFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
    }
    
    func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
