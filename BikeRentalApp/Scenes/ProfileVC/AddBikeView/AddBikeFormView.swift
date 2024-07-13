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
    
    @State private var price: String = ""
    @State private var year: String = ""
    @State private var hasLights: Bool = false
    @State private var numberOfGears: String = ""
    @State private var geometry: String = ""
    @State private var locationLatitude: String = ""
    @State private var locationLongitude: String = ""
    @State private var brakeType: String = ""
    @State private var image: String = ""
    @State private var detailedImages: String = ""
    @State var photoPicker: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    
    private let storage = Storage.storage().reference()
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
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
    }
    
    private func addBike() {
        guard let priceValue = Double(price),
              let yearValue = Int(year),
              let numberOfGearsValue = Int(numberOfGears),
              let locationLatitudeValue = Double(locationLatitude),
              let locationLongitudeValue = Double(locationLongitude),
              !image.isEmpty else {
            print("Please fill in all required fields")
            return
        }
        
        let detailedImagesArray = detailedImages.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        viewModel.addBike(
            price: priceValue,
            year: yearValue,
            hasLights: hasLights,
            numberOfGears: numberOfGearsValue,
            geometry: geometry,
            latitude: locationLatitudeValue,
            longitude: locationLongitudeValue,
            brakeType: brakeType,
            image: image,
            detailedImages: detailedImagesArray
        )
    }
}

#Preview {
    AddBikeFormView()
}
