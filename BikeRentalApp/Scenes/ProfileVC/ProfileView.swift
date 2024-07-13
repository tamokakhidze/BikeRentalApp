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

@available(iOS 16.0, *)
struct ProfileView: View {
    @State var photoPicker: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    @StateObject var viewModel = ProfileViewModel()
    
    let imageUrls = [
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg",
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg",
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg"
    ]
    let prices = [5.4, 6.2, 7.8]
    
    var body: some View {
        NavigationStack {
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
                            if let data = try? await newPhoto?.loadTransferable(type: Data.self)
                            {
                                selectedImageData = data
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(width: 20)
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.username ?? "")")
                        
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
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                            
                            HStack {
                                Text("You have rented \(viewModel.currentRentals.count) bikes")
                                    .foregroundStyle(.white)
                                    .fontWeight(.thin)
                                    .font(.system(size: 14))
                            }
                            
                            Text("You have \(viewModel.points) points")
                                .foregroundStyle(.gray)
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                            
                            HStack {
                                Button("See leaderboard") {
                                    
                                }
                                .frame(height: 34)
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .background(.black)
                                .cornerRadius(50)
                                
                                Button("Sign Out") {
                                    
                                }
                                .frame(height: 34)
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .background(.black)
                                .cornerRadius(50)
                            }
                           
                        }
                        .padding(.leading, 40)
                        
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
                
                ZStack {
                    Rectangle()
                        .fill(.darkBackground)
                        .cornerRadius(16)
                        .frame(height: 140)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            Text("Your current rentals")
                                .foregroundStyle(.white)
                                .fontWeight(.thin)
                                .font(.system(size: 14))
                                .padding(.top, 20)
                                .padding(.leading, 30)
                            
                            LazyVGrid(columns: [GridItem(.flexible(minimum: 270, maximum: .infinity))], spacing: 18) {
                                ForEach(0..<viewModel.currentRentals.count, id: \.self) { index in
                                    RentHistoryCell(bike: "Bike", totalPrice: Double(viewModel.currentRentals[index].totalPrice) ?? 0.0, startTime: viewModel.currentRentals[index].startTime, endTime: viewModel.currentRentals[index].endTime)
                                    }
                            }
                        }
                    }
                }
                Spacer()
            }.onAppear {
                viewModel.fetchUserInfo()
            }
            .padding()
            .padding(.top)
            
        }.navigationTitle("My Profile")
    
    }
    
    
}

#Preview {
    ProfileView()
}
