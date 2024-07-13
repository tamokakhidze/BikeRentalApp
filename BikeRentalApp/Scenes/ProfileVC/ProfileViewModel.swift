//
//  ProfileViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 11.07.24.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import Firebase

final class ProfileViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var startTime: String = ""
    @Published var endTime: String = ""
    @Published var points: Int = 0
    @Published var currentRentals: [Booking] = []
    private var userId = Auth.auth().currentUser?.uid
    
    let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }

    func fetchUserInfo() {
        guard let userId = userId else {
            print("User not autenticated")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        FirestoreService.shared.fetchData(from: userRef, as: UserInfo.self) { [weak self] result in
            switch result {
            case .success(let userInfo):
                DispatchQueue.main.async {
                    self?.username = userInfo.documentID ?? ""
                    self?.currentRentals = userInfo.currentRentals ?? []
                    self?.points = userInfo.points ?? 0
                    
                    // Additional debug prints
                    print("Fetched user info:")
                    print("Username: \(self?.username ?? "nil")")
                    print("Current Rentals: \(String(describing: self?.currentRentals))")
                    print("Points: \(String(describing: self?.points))")
                }
            case .failure(let error):
                print("Failed to fetch user info: \(error.localizedDescription)")
            }
        }
    }
    
    func addBike(price: Double, year: Int, hasLights: Bool, numberOfGears: Int, geometry: String, latitude: Double, longitude: Double,   brakeType: String, image: String, detailedImages: [String]) {
        
        let bikesRef = Firestore.firestore().collection("bikes")
        
        let newBike = BikeToEncode(id: UUID().uuidString, price: price, location: GeoPoint(latitude: latitude, longitude: longitude), year: year, hasLights: hasLights, numberOfGears: numberOfGears, geometry: geometry, brakeType: brakeType, image: image, detailedImages: detailedImages)

        FirestoreService.shared.uploadData(newBike, to: bikesRef) { result in
            switch result {
            case .success:
                print("Bike added successfully")
            case .failure(let error):
                print("Failed to add bike: \(error.localizedDescription)")
            }
        }
    }
}

