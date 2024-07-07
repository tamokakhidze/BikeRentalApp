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
    }
    
    public func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            navigationController = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        else {
            navigationController = UINavigationController(rootViewController: LandingViewController())
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}

