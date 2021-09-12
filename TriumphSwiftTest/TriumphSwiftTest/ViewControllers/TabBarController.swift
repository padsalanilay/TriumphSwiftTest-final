//
//  TabBarController.swift
//  TriumphSwiftTest
//
//  Created by Nilay Padsala on 9/10/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Dark mode for everything
        if #available(iOS 13.0, *) {
            UIWindow.appearance().overrideUserInterfaceStyle = .dark
        }
        
        tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addTabItems()
    }

    func addTabItems() {
        let controllers = [GoodViewController(), OrganizationsViewController()]
        
        // tab bar items
        let tabBarItem1 = UITabBarItem(title: "User", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        let tabBarItem2 = UITabBarItem(title: "Organizations", image: UIImage(systemName: "building.2.crop.circle"), selectedImage: UIImage(systemName: "building.2.crop.circle.fill"))

        controllers[0].tabBarItem = tabBarItem1
        controllers[1].tabBarItem = tabBarItem2
        
        viewControllers = controllers
    }

}
