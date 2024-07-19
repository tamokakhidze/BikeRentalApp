//
//  UsersScrollView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

struct UsersScrollView: View {
    
    @ObservedObject var viewModel: LeaderBoardViewModel
    
    var body: some View {
        ScrollView {
            VStack() {
                ForEach(viewModel.users) { user in
                    if user.points ?? 0 > 0 {
                        ScrollItem(username: user.username ?? "Unknown", joinDate: "", points: user.points ?? 0, image: user.image ?? "")
                        
                    }
                }
            }
            .background(.white)
            .cornerRadius(40)
        }
    }
}


struct ScrollItem: View {
    
    let username: String
    let joinDate: String
    let points: Int
    let image: String
    
    var body: some View {
        HStack(spacing: 17) {
            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .clipped()
            } placeholder: {
                Image(systemName: "person.fill")
            }
            .frame(width: 50, height: 50)
            .cornerRadius(50)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(username)
                    .fontWeight(.medium)
                    .font(.system(size: 12))
                    .foregroundStyle(.black)
                
                Text(joinDate)
                    .font(.system(size: 10))
                    .fontWeight(.light)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
            
            Text("\(points)")
                .fontWeight(.bold)
                .font(.system(size: 12))
                .foregroundStyle(.black)
            
        }
        .padding(EdgeInsets(top: 17, leading: 23, bottom: 17, trailing: 23))
        
        Divider()
            .background(Color.gray.opacity(1))
            .frame(height: 0.5)
    }
    
    
}

#Preview {
    LeaderboardView()
}
