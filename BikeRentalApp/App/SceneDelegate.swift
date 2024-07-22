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
        showLaunchScreen()

        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: NSNotification.Name("UserDidLogout"), object: nil)
    }
    
    private func showLaunchScreen() {
        let launchScreenVC = LaunchScreenViewController()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
        
        loadDataAndTransition()
    }
    
    private func loadDataAndTransition() {
        DispatchQueue.global().async {
            sleep(4)
            DispatchQueue.main.async {
                self.checkIfUserIsLoggedIn()
            }
        }
    }

    func checkIfUserIsLoggedIn() {
           if Auth.auth().currentUser == nil {
               navigationController.setViewControllers([LoginViewController()], animated: false)
           } else {
               navigationController.setViewControllers([RootViewController()], animated: false)
           }
           window?.rootViewController = navigationController
           window?.makeKeyAndVisible()
       }

    @objc func userDidLogout() {
        checkIfUserIsLoggedIn()
    }
}

