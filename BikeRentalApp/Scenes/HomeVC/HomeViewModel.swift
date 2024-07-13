//
//  HomeViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import Foundation
import FirebaseFirestore
import CoreLocation

// MARK: - Protocols

protocol HomeViewModelDelegate: AnyObject {
    func scrollToItem(at indexPath: IndexPath, animated: Bool)
    func updatePageControl(currentPage: Int)
}

// MARK: - HomeViewModel

class HomeViewModel {
    
    private var db = Firestore.firestore()
    var salesImagesArray = [
        "https://i.pinimg.com/564x/56/cf/5d/56cf5d78276232d62cd866397494118b.jpg",
        "https://i.pinimg.com/564x/56/cf/5d/56cf5d78276232d62cd866397494118b.jpg"
    ]
    weak var delegate: HomeViewModelDelegate?
    var bikes = [Bike]()
    var locations = [CLLocation]()
    var currentIndex = 0
    var timer: Timer?
    
    func fetchData(completion: @escaping () -> Void) {
        db.collection("bikes").getDocuments { (querySnapshot, error) in
            if let error = error {
                //print("Error fetching documents: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                //print("No documents found")
                completion()
                return
            }
            
            //print("Documents fetched: \(documents.count)") // Print the number of documents fetched
            
            self.bikes = documents.compactMap { document in
                do {
                    //print("Document data: \(document.data())") // Print the document data
                    let bike = try document.data(as: Bike.self)
                    //print("Bike fetched: \(bike)") // Print each bike fetched
                    return bike
                } catch {
                    //print("Error decoding bike: \(error.localizedDescription)")
                    return nil
                }
            }
            
            self.locations = self.bikes.map { CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude) }
            //print("Bikes count after mapping: \(self.bikes.count)") // Print the count of bikes after mapping
            completion()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(automateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func automateSlider() {
        let nextPage = currentIndex + 1
        let positionToScroll: IndexPath
        
        if nextPage < salesImagesArray.count {
            positionToScroll = IndexPath(item: nextPage, section: 0)
        } else {
            positionToScroll = IndexPath(item: 0, section: 0)
        }
        
        currentIndex = positionToScroll.item
                
        delegate?.scrollToItem(at: positionToScroll, animated: true)
        delegate?.updatePageControl(currentPage: currentIndex)
    }
    
    func pageControlChanged(to page: Int) {
        let selectedPage = page
        let positionToScroll = IndexPath(item: selectedPage, section: 0)
        
        delegate?.scrollToItem(at: positionToScroll, animated: true)
        currentIndex = selectedPage
    }
}
