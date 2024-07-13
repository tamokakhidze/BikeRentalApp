//
//  SuccessViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 11.07.24.
//

import UIKit

// MARK: - SuccessViewController

final class SuccessViewController: UIViewController {

    // MARK: - Ui components and properties

    private var goToProfileButton = CustomButton(title: "Go to profile", hasBackground: true)
    private var stackView = UIStackView()
    private var titleLabel = CustomUiLabel(fontSize: 28, text: "Congrats!", tintColor: .black, textAlignment: .left)
    private var smallTitle = CustomUiLabel(fontSize: 14, text: "Check rental status on your profile", tintColor: .lightGray, textAlignment: .center, fontWeight: .semibold)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        addTargets()
    }
    
    // MARK: - Ui setup

    private func setupUi() {
        view.backgroundColor = .loginBackground
        stackView = configureMainStackView()
        navigationItem.hidesBackButton = true
    }
    
    private func configureMainStackView() -> UIStackView {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        stackView.addArrangedSubviews(titleLabel, smallTitle, goToProfileButton, UIView())
        
        return stackView
    }
    
    // MARK: - Actions

    private func addTargets() {
        goToProfileButton.addTarget(self, action: #selector(didTapGoToProfile), for: .touchUpInside)
    }
    
    
    @objc private func didTapGoToProfile() {
        let vc = RootViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}

