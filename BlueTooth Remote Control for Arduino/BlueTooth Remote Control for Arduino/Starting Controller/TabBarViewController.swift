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
        view.backgroundColor = .systemBackground
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
           setupViewControllers()
    }
    
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        
        return navController
    }
    
    func setupViewControllers() {
            viewControllers = [
                createNavController(for: RemoteViewController(), title: NSLocalizedString(TabBarAspect.TabBarName[0], comment: ""), image: TabBarAspect.TabBarImage[0]),
                createNavController(for: ConfigurationViewController(), title: NSLocalizedString(TabBarAspect.TabBarName[1], comment: ""), image: TabBarAspect.TabBarImage[1]),
                createNavController(for: DemoViewController(), title: NSLocalizedString(TabBarAspect.TabBarName[2], comment: ""), image: TabBarAspect.TabBarImage[2]),
                createNavController(for: SendingFileViewController(), title: NSLocalizedString(TabBarAspect.TabBarName[3], comment: ""), image: TabBarAspect.TabBarImage[3])
            ]
        }
}

