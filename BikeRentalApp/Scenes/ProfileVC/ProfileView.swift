//
//  ProfileView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import PhotosUI
import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

@available(iOS 16.0, *)
struct ProfileView: View {
    @State var photoPicker: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    @StateObject var viewModel = ProfileViewModel()
    @State var image: String = ""
    private let storage = Storage.storage().reference()
    @State var rating = 4
    
    let imageUrls = [
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg",
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg",
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg"
    ]
    let prices = [5.4, 6.2, 7.8]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 30) {
                    HStack {
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
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(50)
                                    .clipped()
                            } else if let image = viewModel.image {
                                AsyncImage(url: URL(string: image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .scaledToFill()
                                        .clipped()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .cornerRadius(50)
                            }
                            else {
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
                                            viewModel.uploadImage(image: image)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(width: 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(viewModel.username)")
                            
                            Spacer()
                            
                            NavigationLink(destination: AddBikeFormView()) {
                                Text("Add your bike")
                                    .foregroundStyle(.gray)
                            }
                            
                        }
                        .frame(height: 50)
                        
                        Spacer()
                        
                    }.padding(.leading)
                    
                    
                    ZStack {
                        Rectangle()
                            .fill(.darkBackground)
                            .frame(height: 126)
                            .cornerRadius(16)
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Current rentals summary and points")
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .font(.system(size: 20))
                                
                                HStack {
                                    Text("You have rented \(viewModel.allRentals.count) bikes")
                                        .foregroundStyle(.white)
                                        .fontWeight(.thin)
                                        .font(.system(size: 14))
                                }
                                
                                Text("You have \(viewModel.points) points")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.thin)
                                    .font(.system(size: 14))
                                
                            }
                            .padding()
                            
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Text("Saved Bikes")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        
                        Spacer()
                    }.padding(.leading)
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.flexible(minimum: 136, maximum: 136))], spacing: 1) {
                            ForEach(0..<imageUrls.count, id: \.self) { index in
                                GridCellView(imageUrl: imageUrls[index], price: prices[index])
                            }
                        }
                        .padding()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Your current rentals: \(viewModel.ongoingRentals.count)")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                            .padding(.top, 20)
                            .padding(.leading)
                        
                        ForEach(0..<viewModel.ongoingRentals.count, id: \.self) { index in
                            
                            let rental = viewModel.ongoingRentals[index]
                            RentHistoryCell(viewModel: viewModel, number: index,
                                            totalPrice: Double(rental.totalPrice) ?? 0.0,
                                            startTime: viewModel.formatDate(dateString: rental.startTime),
                                            endTime: viewModel.formatDate(dateString: rental.endTime),
                                            isRentEnded: viewModel.formatDate(dateString: rental.endTime) <= Date(),
                                            rateAction: {
                                viewModel.rateBike()
                            }
                            )
                        }.padding()
                    }
                    .background(.darkBackground)
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading) {
                        Text("Rental history: \(viewModel.finishedRentals.count) bikes")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                            .padding(.top, 20)
                            .padding(.leading)
                        
                        ForEach(0..<viewModel.finishedRentals.count, id: \.self) { index in
                            
                            let rental = viewModel.finishedRentals[index]
                            RentHistoryCell(viewModel: viewModel, number: index,
                                            totalPrice: Double(rental.totalPrice) ?? 0.0,
                                            startTime: viewModel.formatDate(dateString: rental.startTime),
                                            endTime: viewModel.formatDate(dateString: rental.endTime),
                                            isRentEnded: viewModel.formatDate(dateString: rental.endTime) <= Date(),
                                            rateAction: {
                                viewModel.rateBike()
                            }
                            )
                        }.padding()
                    }
                    .background(.darkBackground)
                    .cornerRadius(16)
                    
                    Spacer()
                }.onAppear {
                    viewModel.fetchUserInfo()
                }
                .padding()
                .padding(.top)
            }
        }.navigationTitle("My Profile")
        
    }
    
    
}

#Preview {
    ProfileView()
}
