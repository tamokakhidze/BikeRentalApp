//
//  RootViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        navigationItem.hidesBackButton = true
    }
    
    private func setupTabBar() {
        let tabBarController = UITabBarController()
        
        let HomeVC = HomeViewController()
        let LeaderboardVC = LeaderBoardViewController()
        let ProfileVC = ProfileHostingController()
        
        tabBarController.viewControllers = [HomeVC, LeaderboardVC, ProfileVC]
        
        HomeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        LeaderboardVC.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "LeaderboardVC"), tag: 2)
        ProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        tabBarController.tabBar.barTintColor = .lightGray
        tabBarController.tabBar.tintColor = .systemBlue
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}
