//
//  TabBarController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/6/20.
//

import Foundation
import SwiftUI
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let hvc = HomeViewController()
        hvc.title = "Home"
        hvc.tabBarItem = UITabBarItem(title: hvc.title, image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        let homeNavigation = UINavigationController(rootViewController: hvc)
        
        
    }
}
