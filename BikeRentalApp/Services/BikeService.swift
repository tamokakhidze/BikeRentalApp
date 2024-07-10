//
//  BikeService.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class BikeService {
    let db = Firestore.firestore()
    public static let shared = BikeService()
    private init() {}
    
    public func rentBike(with booking: Booking, completion: @escaping (Bool, Error?) -> Void) {
        checkAvailability(for: booking) { available, error in
            if let error = error {
                print("error checkng availability: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard available else {
                print("bike is not available")
                completion(false, nil)
                return
            }
            
            var updatedBooking = booking
            if let currentUser = Auth.auth().currentUser {
                updatedBooking.userID = currentUser.uid
            } else {
                print("user is not logged in")
                completion(false, nil)
                return
            }
            
            let bookings = self.db.collection("bookings")
            bookings.addDocument(data: updatedBooking.dictionary) { error in
                if let error = error {
                    print("cant add booking!: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    print("booking added to database")
                    completion(true, nil)
                }
            }
        }
    }
    
    public func checkAvailability(for bookingRequest: Booking, completion: @escaping (Bool, Error?) -> Void) {
        let requestedStartTime = bookingRequest.startTime
        let requestedEndTime = bookingRequest.endTime
        let bikeId = bookingRequest.bikeID
        
        let bookings = db.collection("bookings")
        let query = bookings.whereField("bikeID", isEqualTo: bikeId)
                            .whereField("startTime", isLessThanOrEqualTo: requestedEndTime)
                            .whereField("endTime", isGreaterThanOrEqualTo: requestedStartTime)
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting availability data: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                print("Bike is not available in this period")
                completion(false, nil)
            } else {
                print("Bike is available")
                completion(true, nil)
            }
        }
    }
}
