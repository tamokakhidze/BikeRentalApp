//
//  LeaderboardViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import Foundation
import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - LeaderBoardViewModel

class LeaderBoardViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var users = [UserInfo]()
    @Published var topThreeUser = [UserInfo]()

    // MARK: - Fetching users info

    func fetchUserInfo() {
        let users = Firestore.firestore().collection("users")
        
        FirestoreService.shared.fetchCollectionData(from: users, as: UserInfo.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.users = success.sorted( by: {$0.points ?? 0 > $1.points ?? 0} )
                print("Total users fetched: \(self?.users.count ?? 0)")
                if success.count >= 3 {
                    self?.topThreeUser = Array(self?.users.prefix(3) ?? [])
                    print("top 3 users fetched: \(self?.topThreeUser.count ?? 0)")
                }
                print(self?.users)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

