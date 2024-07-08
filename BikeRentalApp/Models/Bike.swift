//
//  Bike.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import Foundation
import CoreLocation

struct Bike {
    var id: Int
    var price: Double
    var year: Int
    var isAvailable: Bool
    var hasLights: Bool
    var numberOfGears: Int
    var geometry: String
    var location: CLLocationCoordinate2D
    var brakeType: String
    var image: String
    var detailedImages: [String]
    var documentID: String
}

