//
//  CustomButton.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

class CustomButton: UIButton {

    init(title: String, hasBackground: Bool = false, width: CGFloat = 350) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = hasBackground ? .black: .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: hasBackground ? 50 : 25).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.layer.cornerRadius = 25
        self.titleLabel?.font = .systemFont(ofSize: hasBackground ? 14 : 12)
        self.setTitleColor(hasBackground ? .white : .systemBlue, for: .normal)
        self.setTitleColor(.systemGray, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
