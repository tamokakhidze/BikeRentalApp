//
//  ImageClassifier.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 22.07.24.
//

import CoreImage
import FirebaseFirestore
import Firebase

class AddBikeFormViewModel: ObservableObject {
    @Published private var classifier = Classifier()
    @Published var isAddBikeButtonEnabled = true

    var isValid: Bool? {
        classifier.isValid
    }

    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage(image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
    }
    
    func addBike(bike: Bike, completion: @escaping (Result<Void, Error>) -> Void) {
        let bikesRef = Firestore.firestore().collection("bikes")
        
        do {
            try bikesRef.addDocument(from: bike) { error in
                if let error = error {
                    print("Failed to add bike: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Bike added successfully")
                    completion(.success(()))
                }
            }
        } catch {
            print("Failed to encode bike: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
