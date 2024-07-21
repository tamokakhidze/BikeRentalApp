//
//  SceneDelegate.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        checkIfUserIsLoggedIn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: NSNotification.Name("UserDidLogout"), object: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            let navController = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = navController
        } else {
            let rootViewController = RootViewController()
            navigationController.viewControllers = [rootViewController]
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
    }
    
    @objc func userDidLogout() {
        checkIfUserIsLoggedIn()
    }
}
