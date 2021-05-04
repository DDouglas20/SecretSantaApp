//
//  TabBarController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/3/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create instances of the view controllers
        let homeScreenVC = UINavigationController(rootViewController: HomeScreen())
        homeScreenVC.title = "Home Screen"
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.title = "Settings"
        
        // Assign view controllers to tab bar
        self.setViewControllers([homeScreenVC, settingsVC], animated: false)
        
        // Assign images to tab bar items
        guard let items = self.tabBar.items else {
            print("Could not get tab bar items")
            return
        }
        
        let images = ["person.crop.circle.fill", "gear"]
        
        for x in 0...1 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        // Tint Color
        self.tabBar.tintColor = .black
        
        

        // Do any additional setup after loading the view.
    }
    

    

}




