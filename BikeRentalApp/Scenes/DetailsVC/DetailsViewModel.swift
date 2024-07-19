//
//  DetailsViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 19.07.24.
//

import Foundation

protocol DetailsViewModelDelegate: AnyObject {
    func scaleUp()
    func scaleDown()
}
class DetailsViewModel {
    
    private var playButtonClicked = true
    weak var delegate: DetailsViewModelDelegate?
    
    @objc func playButtonClick(_ sender: Any) {
        
        if playButtonClicked {
            playButtonClicked = false
            delegate?.scaleDown()
            
        }
        else {
            playButtonClicked = true
            delegate?.scaleUp()
        }
    }
    
}

