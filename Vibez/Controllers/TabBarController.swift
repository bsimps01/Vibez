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
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .black
    }
    
    func setupViewControllers() {
        let hvc = HomeViewController()
        hvc.title = "Home"
        hvc.tabBarItem = UITabBarItem(title: hvc.title, image: UIImage(named: "earth"), selectedImage: UIImage(named: "earth"))
        let homeNavigation = UINavigationController(rootViewController: hvc)
        
        let favArtist = FavoriteArtistsViewController()
        favArtist.title = "Your Artists"
        favArtist.tabBarItem = UITabBarItem(title: favArtist.title, image: UIImage(named: "artist"), selectedImage: UIImage(named: "artist"))
        let favoriteArtistsNavigation = UINavigationController(rootViewController: favArtist)
        
        let favVc = FavoritesViewController()
        favVc.title = "Favorites"
        favVc.tabBarItem = UITabBarItem(title: favVc.title, image: UIImage(named: "favorite"), selectedImage: UIImage(named: "favorite"))
        let favoriteNavigation = UINavigationController(rootViewController: favVc)
        
        viewControllers = [homeNavigation, favoriteArtistsNavigation, favoriteNavigation]
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected a new view controller")
    }
}
