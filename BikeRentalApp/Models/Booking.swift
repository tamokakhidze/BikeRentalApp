//
//  Booking.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import Foundation

struct Booking {
    var bookingID: String
    var startTime: String
    var endTime: String
    var userID: String
    var bikeID: String

    init(dictionary: [String: Any]) {
        self.bookingID = dictionary["bookingID"] as? String ?? ""
        self.startTime = dictionary["startTime"] as? String ?? ""
        self.endTime = dictionary["endTime"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
        self.bikeID = dictionary["bikeID"] as? String ?? ""
    }

    var dictionary: [String: Any] {
        return [
            "bookingID": bookingID,
            "startTime": startTime,
            "endTime": endTime,
            "userID": userID,
            "bikeID": bikeID
        ]
    }
}
