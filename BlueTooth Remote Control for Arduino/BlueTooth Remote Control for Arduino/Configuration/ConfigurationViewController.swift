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
    var dataProfile = String()
    let saveButton = UIButton()
    let activityIndicator = UIActivityIndicatorView()
    let scrollView = UIScrollView()
    
    var timer = Timer()
    
    var profileSaving = Profile(name: "", datas:"")
    
    var activeField: UITextField?
    
    var uuidInUse = UUID()
    
    var test = ""
    var profileReceivedToBeLoaded = Profile(name: "", datas: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tryWithTableView()
        setup()
        setView()
        setConstraints()
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("test01 : \(test)")
        if profileReceivedToBeLoaded != Profile(name: "", datas: "") {
            loadingProfile(profileToLoad: profileReceivedToBeLoaded)
            profileReceivedToBeLoaded = Profile(name: "", datas: "")
        }
        
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
        
        //saveButton.heightAnchor.constraint(equalToConstant: 60) //???
        //saveButton.widthAnchor.constraint(equalToConstant: 60)
        //saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 1.0/1.0)
        
        view.backgroundColor = appColors.backgroundColor
        
        // 4 StackView = green line
        line.layer.cornerRadius = 4
        line.layer.masksToBounds = true
        line.backgroundColor = .green
        
        // 5 StackView = datasName
        dataName01.layer.cornerRadius = 4
        dataName01.layer.masksToBounds = true
        dataName01.backgroundColor = .lightGray
        dataName01.placeholder = "First data's name"
        
        dataName02.layer.cornerRadius = 4
        dataName02.layer.masksToBounds = true
        dataName02.backgroundColor = .lightGray
        dataName02.placeholder = "Second data's name"
        
        
        // 6 StackView = SaveName and Save button
        nameProfile.layer.cornerRadius = 2
        nameProfile.layer.masksToBounds = true
        nameProfile.placeholder = "Save's name"
        nameProfile.backgroundColor = .lightGray
        
        saveButton.backgroundColor = appColors.buttonColor
        saveButton.setTitle("Save", for: .normal)
        saveButton.contentMode = .scaleAspectFit
        saveButton.layer.cornerRadius = 4
        saveButton.layer.masksToBounds = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.stopAnimating()
        
    }
    
    // MARK: - Constraints
    
    func setConstraints() {
        let margins = view.layoutMarginsGuide
        // Faire un tableau de StackView et une boucle for ?
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
        
        let separatorStackView = UIStackView(arrangedSubviews: [line])
        separatorStackView.axis = .horizontal
        separatorStackView.alignment = .fill
        separatorStackView.distribution = .fillEqually
        separatorStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorStackView)
        
        let datasReceivedStackView = UIStackView(arrangedSubviews: [dataName01,dataName02])
        datasReceivedStackView.axis = .horizontal
        datasReceivedStackView.alignment = .fill
        datasReceivedStackView.distribution = .fillEqually
        datasReceivedStackView.spacing = 5
        datasReceivedStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datasReceivedStackView)
        
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
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        initializeButtons()
        sender.backgroundColor = appColors.selectedButtonColor
        resigningFirstResponder()
    }
    
    @objc func save(sender: UIButton!) {
        
        for button in buttonsForConfiguration { // First of all, let's check there are no :
            
            if let buttonName = button.nameTextField.text, let buttonOrder = button.orderTextField.text, let data01 = dataName01.text, let data02 = dataName02.text {
                if buttonName.contains(":") || buttonOrder.contains(":") || data01.contains(":") || data02.contains(":") {
                    allErrors(errorMessage: "Don't use : ", errorTitle: "Forbidden character used")
                    return
                }
            }
        }
        resigningFirstResponder()
        nameProfile.isHidden = true
        saveButton.isHidden = true
        activityIndicator.startAnimating()
        // On lance le chrono. Une fois le temps écoulé il va lancer fireTimer.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        
        groupDatasInArray()
        
        if var name = nameProfile.text {
            if name == "" {
                name = "Save"
            }
            profileSaving.name = name
        }
        
        profileSaving.datas = dataProfile
        
        //Ajout UUID
        
        let profileToSave = profileSaving
        
        do {
            print("Try to save")
            try profileStorageManager.saveProfile(profile: profileToSave)
        } catch {
            print("Error while saving")
        }
        
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        nameProfile.isHidden = false
        saveButton.isHidden = false
        activityIndicator.stopAnimating()
        timer.invalidate()
        initializeDatasButtons()
 
    }
    
    func loadingProfile(profileToLoad: Profile) {
        /*
        // Let's delete the profile to edit from Storage
        do {
            print("On efface")
            try self.profileStorageManager.deleteProfile(profileToDelete: profileToLoad)
            
        } catch {
            print("Error while deleting")
            let error = AppError.errorDelete
            if let errorMessage = error.errorDescription, let errorTitle = error.failureReason {
                self.allErrors(errorMessage: errorMessage, errorTitle: errorTitle)
            }
        }
        */
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
    
    func groupDatasInArray() {
        dataProfile = ""
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
        print("\(dataProfile)")
    }
    
    func initializeDatasButtons() {
        for button in buttonsForConfiguration {
            button.nameTextField.text = ""
            button.orderTextField.text = ""
            button.button.setTitle("", for: .normal)
            nameProfile.text = ""
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
    
    func allErrors(errorMessage: String, errorTitle: String) {
        let alertVC = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated: true,completion: nil)
    }
}
