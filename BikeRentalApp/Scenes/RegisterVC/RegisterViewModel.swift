//
//  RegisterViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import Foundation
import FirebaseAuth

protocol RegisterViewModelDelegate: AnyObject {
    func registrationCompleted(success: Bool, error: Error?)
}

class RegisterViewModel {
    
    weak var delegate: RegisterViewModelDelegate?
    
    func registerUser(username: String, email: String, password: String) {
        let registerUserRequest = RegisterRequest(username: username, email: email, password: password)
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.registrationCompleted(success: false, error: error)
                return
            }
            
            if wasRegistered {
                self.delegate?.registrationCompleted(success: true, error: nil)
            } else {
                self.delegate?.registrationCompleted(success: false, error: nil)
            }
        }
    }
}
