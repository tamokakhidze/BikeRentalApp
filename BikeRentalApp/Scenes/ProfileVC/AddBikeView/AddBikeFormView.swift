//
//  AddBikeFormView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 12.07.24.
//

import SwiftUI
import _PhotosUI_SwiftUI
import FirebaseStorage

struct AddBikeFormView: View {
    
    @State private var price = ""
    @State private var year = ""
    @State private var hasLights = false
    @State private var numberOfGears = ""
    @State private var geometry = ""
    @State private var locationLatitude = ""
    @State private var locationLongitude = ""
    @State private var brakeType = ""
    @State private var image = ""
    @State private var detailedImages = ""
    @State private var hasHelmet = false
    @State private var helmetPrice = ""
    
    @State private var photoPicker: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var message = ""
    @State private var showPopup = false
    private let storage = Storage.storage().reference()
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical) {
                    
                    Form {
                        Section(header: Text("Enter bike details")) {
                            TextField("Bike Price", text: $price)
                                .keyboardType(.decimalPad)
                            TextField("Year", text: $year)
                                .keyboardType(.numberPad)
                            Toggle("Does your bike have lights?", isOn: $hasLights)
                            TextField("Number of Gears", text: $numberOfGears)
                                .keyboardType(.numberPad)
                            TextField("Geometry", text: $geometry)
                            TextField("Location Latitude", text: $locationLatitude)
                                .keyboardType(.decimalPad)
                            TextField("Location Longitude", text: $locationLongitude)
                                .keyboardType(.decimalPad)
                            TextField("Brake Type", text: $brakeType)
                            TextField("Image URL", text: $image)
                            TextField("Detailed Images (comma separated)", text: $detailedImages)
                            Toggle("Does your bike have helmet?", isOn: $hasHelmet)
                            TextField("Helmet Price", text: $helmetPrice)
                                .keyboardType(.decimalPad)
                            
                        }
                    }
                    .frame(height: 500)
                    
                    PhotosPicker(
                        selection: $photoPicker,
                        matching: .images,
                        photoLibrary: .shared()
                    )
                    {
                        if let selectedImageData,
                           let profileImage = UIImage(data: selectedImageData) {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                    }
                    .onChange(of: photoPicker) { newPhoto in
                        Task {
                            if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                
                                let imageRef = storage.child("images/\(UUID().uuidString).jpg")
                                
                                imageRef.putData(data, metadata: nil) { metadata, error in
                                    guard metadata != nil else {
                                        print("error uploading image")
                                        return
                                    }
                                    
                                    imageRef.downloadURL { url, error in
                                        guard let downloadURL = url else {
                                            return
                                        }
                                        image = downloadURL.absoluteString
                                        print("download phot urll : \(image)")
                                    }
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        addBike()
                    }, label: {
                        Text("Add your bike")
                            .frame(width: 350, height: 50)
                            .background(.darkBackground)
                            .cornerRadius(50)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    })
                    
                    Spacer()
                    
                }
            }
            
            if showPopup {
                AlertView(showPopup: $showPopup, message: $message)
            }
            
        }
    }
    
    private func addBike() {
        guard let priceValue = Double(price),
              let yearValue = Int(year),
              let numberOfGearsValue = Int(numberOfGears),
              !geometry.isEmpty,
              let locationLatitudeValue = Double(locationLatitude),
              let locationLongitudeValue = Double(locationLongitude),
              !brakeType.isEmpty,
              let helmetPriceValue = Double(helmetPrice),
              !image.isEmpty else {
            message = "Please fill in all required fields correctly"
            showPopup = true
            return
        }
         
        let detailedImagesArray = detailedImages.components(separatedBy: ",").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
         
         let bike = Bike(
             price: priceValue,
             year: yearValue,
             hasLights: hasLights,
             numberOfGears: numberOfGearsValue,
             geometry: geometry,
             locationLatitude: locationLatitudeValue,
             locationLongitude: locationLongitudeValue,
             brakeType: brakeType,
             image: image,
             detailedImages: detailedImagesArray,
             hasHelmet: hasHelmet,
             helmetPrice: helmetPriceValue
         )
         
         viewModel.addBike(bike: bike) { result in
             switch result {
             case .success:
                 message = "Bike added successfully!"
             case .failure(let error):
                 message = "Failed to add bike: \(error.localizedDescription)"
             }
             showPopup = true
         }
     }
}

#Preview {
    AddBikeFormView()
}
