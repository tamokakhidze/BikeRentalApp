//
//  Bike.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//
import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import FirebaseFirestore

struct Bike: Identifiable, Decodable {
    @DocumentID var id: String?
    var price: Double = 0.0
    var year: Int = 0
    var hasLights: Bool = false
    var numberOfGears: Int = 0
    var geometry: String = ""
    var locationLatitude: Double = 0.0
    var locationLongitude: Double = 0.0
    var brakeType: String = ""
    var image: String = ""
    var detailedImages: [String] = []

    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case price
        case year
        case hasLights
        case numberOfGears
        case geometry
        case location
        case brakeType
        case image
        case detailedImages
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0.0
        self.year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        self.hasLights = try container.decodeIfPresent(Bool.self, forKey: .hasLights) ?? false
        self.numberOfGears = try container.decodeIfPresent(Int.self, forKey: .numberOfGears) ?? 0
        self.geometry = try container.decodeIfPresent(String.self, forKey: .geometry) ?? ""
        self.brakeType = try container.decodeIfPresent(String.self, forKey: .brakeType) ?? ""
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.detailedImages = try container.decodeIfPresent([String].self, forKey: .detailedImages) ?? []

        let geoPoint = try container.decode(FirebaseFirestore.GeoPoint.self, forKey: .location)
        self.locationLatitude = geoPoint.latitude
        self.locationLongitude = geoPoint.longitude
    }
}


import FirebaseFirestoreSwift
import FirebaseFirestore

struct BikeToEncode: Codable {
    var id: String
    var price: Double
    var location: GeoPoint
    var year: Int
    var hasLights: Bool
    var numberOfGears: Int
    var geometry: String
    var brakeType: String
    var image: String
    var detailedImages: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case price
        case location
        case year
        case hasLights
        case numberOfGears
        case geometry
        case brakeType
        case image
        case detailedImages
    }
}
