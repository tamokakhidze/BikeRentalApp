//
//  UserInfo.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 12.07.24.
//

import FirebaseFirestoreSwift

struct UserInfo: Codable {
    @DocumentID var documentID: String?
    var currentRentals: [Booking]?
    var points: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentRentals, points
    }
}
