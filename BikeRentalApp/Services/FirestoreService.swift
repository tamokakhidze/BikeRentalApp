//
//  FirestoreService.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 11.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreFetchable {
    func fetchData<T: Decodable>(from documentRef: DocumentReference, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func uploadData<T: Encodable>(_ data: T, to documentRef: CollectionReference, completion: @escaping (Result<Void, Error>) -> Void)
}

class FirestoreService: FirestoreFetchable {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchData<T: Decodable>(from documentRef: DocumentReference, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        documentRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                return
            }
            
            do {
                if let data = document.data() {
                    let decodedData = try Firestore.Decoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } else {
                    completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode document"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func uploadData<T: Encodable>(_ data: T, to documentRef: CollectionReference, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try documentRef.addDocument(from: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
