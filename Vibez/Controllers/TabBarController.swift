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
        self.delegate = self
    }
    
    func setupViewControllers() {
        let hvc = HomeViewController()
        hvc.title = "Home"
        hvc.tabBarItem = UITabBarItem(title: hvc.title, image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        let homeNavigation = UINavigationController(rootViewController: hvc)
        
        let favVc = FavoritesViewController()
        favVc.title = "Favorites"
        favVc.tabBarItem = UITabBarItem(title: favVc.title, image: UIImage(named: "favorite"), selectedImage: UIImage(named: "favorite"))
        let favoriteNavigation = UINavigationController(rootViewController: favVc)
        
        viewControllers = [homeNavigation, favoriteNavigation]
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected a new view controller")
    }
}
