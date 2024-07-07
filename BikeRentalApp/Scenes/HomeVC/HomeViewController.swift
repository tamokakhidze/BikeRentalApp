//
//  HomeViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

//დროებით

final class HomeViewController: UIViewController {
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    private func setupUi() {
        view.backgroundColor = .white
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showAlert(message: error.localizedDescription, on: self, title: "Logout Error")
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkIfUserIsLoggedIn()
            }
        }
    }
}
