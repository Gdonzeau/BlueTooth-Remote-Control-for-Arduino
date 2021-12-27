//
//  TabBarViewController.swift
//  TabBarTry
//
//  Created by Guillaume Donzeau on 22/12/2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.overrideUserInterfaceStyle = .dark
        //overrideUserInterfaceStyle = .light
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
           setupVCs()
    }
    
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        //navController.navigationBar.prefersLargeTitles = true
        //navController.navigationBar.isHidden = true
        navController.navigationBar.prefersLargeTitles = false
        //navController.navigationBar.backgroundColor = .systemGreen
        rootViewController.navigationItem.title = title
        
        return navController
    }
    
    func setupVCs() {
            viewControllers = [
                createNavController(for: RemoteViewController(), title: NSLocalizedString("Remote Control", comment: ""), image: UIImage(systemName: "keyboard")),
                createNavController(for: ConfigurationViewController(), title: NSLocalizedString("Configuration", comment: ""), image: UIImage(systemName: "gear")),
                createNavController(for: DemoViewController(), title: NSLocalizedString("Instructions", comment: ""), image: UIImage(systemName: "book"))
            ]
        }
}

