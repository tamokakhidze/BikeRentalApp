//
//  HomeViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import Foundation
import FirebaseFirestore
import CoreLocation

protocol HomeViewModelDelegate: AnyObject {
    func scrollToItem(at indexPath: IndexPath, animated: Bool)
    func updatePageControl(currentPage: Int)
}

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
    var timer : Timer?
    
    func fetchData(completion: @escaping () -> Void) {
        db.collection("bikes").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents found")
                completion()
                return
            }
            
            self.bikes = documents.map { querySnapshotDocument in
                let data = querySnapshotDocument.data()
                
                let id = data["id"] as! Int
                let price = data["price"] as! Double
                let year = data["year"] as! Int
                let isAvailable = data["isAvailable"] as! Bool
                let hasLights = data["hasLights"] as! Bool
                let numberOfGears = data["numberOfGears"] as! Int
                let geometry = data["geometry"] as! String
                let geoPoint = data["location"] as! GeoPoint
                let brakeType = data["brakeType"] as! String
                let image = data["image"] as! String
                let detailedImages = data["detailedImages"] as! [String]
                let location = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                
                return Bike(
                    id: id,
                    price: price,
                    year: year,
                    isAvailable: isAvailable,
                    hasLights: hasLights,
                    numberOfGears: numberOfGears,
                    geometry: geometry,
                    location: location,
                    brakeType: brakeType,
                    image: image,
                    detailedImages: detailedImages,
                    documentID: querySnapshotDocument.documentID
                )
            }
            
            self.locations = self.bikes.map { CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude) }
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
