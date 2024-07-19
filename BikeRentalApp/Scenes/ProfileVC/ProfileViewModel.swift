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
    @Published var image: String?
    @Published var allRentals: [Booking] = []
    @Published var finishedRentals: [Booking] = []
    @Published var ongoingRentals: [Booking] = []
    
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    func formatDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: dateString) ?? Date()
    }
    

    func fetchUserInfo() {
        guard let userId = userId else {
            print("User not authenticated")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        userRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                do {
                    let userInfo = try document.data(as: UserInfo.self)
                    DispatchQueue.main.async {
                        self.username = userInfo.username ?? "Username"
                        self.allRentals = userInfo.currentRentals ?? []
                        self.finishedRentals = userInfo.currentRentals?.filter {self.formatDate(dateString: $0.endTime) <= Date()} ?? []
                        self.ongoingRentals = userInfo.currentRentals?.filter {self.formatDate(dateString: $0.endTime) > Date()} ?? []
                        self.points = userInfo.points ?? 0
                        self.image = userInfo.image ?? "https://i.pinimg.com/736x/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
                    }
                } catch {
                    print("Failed to fetch user info:\(error.localizedDescription)")
                    print("Error details:\(error)")
                }
            } else {
                print("Document doesn't exist")
            }
        }
    }
    
    func uploadImage(image: String) {
        guard let userId = userId else {
            print("User not authenticated")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            do {
                var userInfo = try document?.data(as: UserInfo.self)
                if userInfo == nil {
                    userInfo = UserInfo(image: image)
                } else {
                        userInfo?.image = image
                }
                
                try userRef.setData(from: userInfo!) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("image updated succesfully")
                    }
                }
            } catch {
                print("Error decoding user document: \(error.localizedDescription)")
            }
        }
    }
    
    func addBike(price: Double, year: Int, hasLights: Bool, numberOfGears: Int, geometry: String, latitude: Double, longitude: Double, brakeType: String, image: String, detailedImages: [String], hasHelmet: Bool, helmetPrice: Double) {
        
        let bikesRef = Firestore.firestore().collection("bikes")
        
        let newBike = Bike(price: price, year: year, hasLights: hasLights, numberOfGears: numberOfGears, geometry: geometry, locationLatitude: latitude, locationLongitude: longitude, brakeType: brakeType, image: image, detailedImages: detailedImages, hasHelmet: hasHelmet, helmetPrice: helmetPrice)
        
        do {
            try bikesRef.addDocument(from: newBike) { error in
                if let error = error {
                    print("Failed to add bike: \(error.localizedDescription)")
                } else {
                    print("Bike added successfully")
                }
            }
        } catch {
            print("Failed to encode bike: \(error.localizedDescription)")
        }
    }
    
    func logOutTapped() {
//        AuthService.shared.signOut { [weak self] error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            } else {
//                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                    sceneDelegate.checkIfUserIsLoggedIn()
//                }
//            }
//        }
    }

    func rateBike() {
        
    }
}

