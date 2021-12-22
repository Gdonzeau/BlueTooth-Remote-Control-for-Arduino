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
    
    override func viewDidLoad() {
        //tryWithTableView()
        setup()
        setView()
        setConstraints()
        configuration()
    }
    func setup() {
        //registerForKeyboardNotifications()
        
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
        //saveButton.heightAnchor.constraint(equalToConstant: 60) //???
        //saveButton.widthAnchor.constraint(equalToConstant: 60)
        //saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 1.0/1.0)
        activityIndicator.stopAnimating()
        view.backgroundColor = appColors.backgroundColor
        line.backgroundColor = .green
        dataName01.backgroundColor = .white
        dataName01.placeholder = "First data's name"
        dataName02.backgroundColor = .white
        dataName02.placeholder = "Second data's name"
        nameProfile.backgroundColor = .white
        nameProfile.placeholder = "Save's name"
        nameProfile.backgroundColor = .lightGray
        
        
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
        dataName01.backgroundColor = .lightGray
        dataName02.layer.cornerRadius = 4
        dataName02.layer.masksToBounds = true
        dataName02.backgroundColor = .lightGray
        fithStackView.axis = .horizontal
        fithStackView.alignment = .fill
        fithStackView.distribution = .fillEqually
        fithStackView.spacing = 5
        fithStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fithStackView)
        
        let sixthStackView = UIStackView(arrangedSubviews: [nameProfile,saveButton,activityIndicator])
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
        
        //let scrollView = UIScrollView()
        /*
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.backgroundColor = .orange
        scrollView.addSubview(globalStackView)
        */
        NSLayoutConstraint.activate([
            
            globalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            
            /*
            globalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            globalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            globalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            globalStackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            */
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
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        initializeButtons()
        sender.backgroundColor = appColors.selectedButtonColor
        resigningFirstResponder()
    }
    
    @objc func save(sender: UIButton!) {
        nameProfile.isHidden = true
        saveButton.isHidden = true
        activityIndicator.startAnimating()
        // On lance le chrono. Une fois le temps écoulé il va lancer fireTimer.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        groupDatasInArray()
        profileSaving.name = nameProfile.text ?? "Save"
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
        deleteButtons()
 
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
    
    func deleteButtons() {
        for button in buttonsForConfiguration {
            button.nameTextField.text = ""
            button.orderTextField.text = ""
            button.button.setTitle("", for: .normal)
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
