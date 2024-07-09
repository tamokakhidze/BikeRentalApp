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
    @State var username: String = "Tamo k"
    
    let imageUrls = [
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg",
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg",
        "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg"
    ]
    let prices = [5.4, 6.2, 7.8]
    
    func getUser() {
        AuthService.shared.getUser { user, error in
            if let user = user {
                DispatchQueue.main.async {
                    self.username = user.username
                }
            } else if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
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
                        Text(username)
                        
                        Spacer()
                        
                        Button("Edit profile") {
                            // editing form view გამოვაჩინო
                        }.foregroundStyle(.gray)
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
                            Text("Current rental status")
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                            
                            HStack {
                                Text("End time:")
                                    .foregroundStyle(.white)
                                    .fontWeight(.thin)
                                    .font(.system(size: 14))
                                
                                Text("12:34, Today")
                                    .foregroundStyle(.gray)
                                    .fontWeight(.medium)
                                    .font(.system(size: 14))
                            }
                            
                            Button("End now") {
                                
                            }
                            .frame(width: 94, height: 34)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .background(.black)
                            .cornerRadius(50)
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
                            Text("Rent history")
                                .foregroundStyle(.white)
                                .fontWeight(.thin)
                                .font(.system(size: 14))
                                .padding(.top, 20)
                                .padding(.leading, 30)
                            
                            LazyVGrid(columns: [GridItem(.flexible(minimum: 270, maximum: .infinity))], spacing: 18) {
                                ForEach(0..<imageUrls.count, id: \.self) { index in
                                    RentHistoryCell(bike: "Mountain Bike", totalPrice: prices[index])
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .padding(.top)
            
        }.navigationTitle("My Profile")
    
    }
    
    
}

#Preview {
    ProfileView()
}
