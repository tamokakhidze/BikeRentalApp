//
//  LandingViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

final class LandingViewController: UIViewController {

    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var stackView = UIStackView()
    private var exploreButton = CustomButton(title: "Explore now", hasBackground: true)
    private var fullMapButton = CustomButton(title: "View map", hasBackground: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    private func setupUi() {
        view.backgroundColor = .mainBackground
        titleLabel = configureTitleLabel()
        subtitleLabel = configureSubtitleLabel()
        stackView = configureMainStackView()
        navigationItem.hidesBackButton = true
        exploreButton.addTarget(self, action: #selector(didTapExploreButton), for: .touchUpInside)
    }
    
    private func configureMainStackView() -> UIStackView {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        stackView.addArrangedSubviews(titleLabel, subtitleLabel, exploreButton, fullMapButton)
        
        return stackView
    }
    
    private func configureTitleLabel() -> UILabel {
        titleLabel.font = .systemFont(ofSize: 35)
        titleLabel.text = "Pedal Through Possibilities"
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        return titleLabel
    }
    
    private func configureSubtitleLabel() -> UILabel {
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.text = "Explore the City with Ease – Rent a Bike Anytime, Anywhere"
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        
        return subtitleLabel
    }
    
    @objc private func didTapExploreButton() {
        navigationController?.pushViewController(RootViewController(), animated: true)
    }
}

