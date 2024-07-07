//
//  CustomInputView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

class CustomInputView: UITextField {
    
    enum InputViewType: CaseIterable {
        case Username, Email, Password
    }
    
    private var inputFieldType: InputViewType
    
    init(inputType: InputViewType ) {
        self.inputFieldType = inputType
        super.init(frame: .zero)
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.returnKeyType = .done
        self.font = .systemFont(ofSize: 14)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        self.layer.cornerRadius = 10
        
        self.backgroundColor = .white
        
        switch inputFieldType {
        case .Username:
            self.placeholder = "Enter username"
        case .Email:
            self.placeholder = "Enter email"
            self.keyboardType = .emailAddress
        case .Password:
            self.placeholder = "Enter password"
            self.isSecureTextEntry = true
            self.textContentType = .oneTimeCode

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

