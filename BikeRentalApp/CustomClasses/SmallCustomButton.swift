//
//  SmallCustomButton.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 04.07.24.
//

import UIKit

class SmallCustomButton: UIButton {
    
    private let imageContainer: UIView
    
    init(width: CGFloat, height: CGFloat, backgroundImage: String, backgroundColor: UIColor) {
        imageContainer = UIView()
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.setBackgroundImage(nil, for: .normal)
        
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = height / 2
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.backgroundColor = .clear
        imageContainer.clipsToBounds = true
        self.addSubview(imageContainer)
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 20),
            imageContainer.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let imageView = UIImageView(image: UIImage(named: backgroundImage)?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        imageContainer.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
        
        self.layer.shadowColor = UIColor(.gray.opacity(0.2)).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 22.9)
        //self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 11.45
        self.layer.masksToBounds = false
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

