//
//  LeaderboardView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

struct LeaderboardView: View {
    
    @StateObject private var viewModel = LeaderBoardViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 113)
                        .foregroundStyle(.darkBackground)
                        .cornerRadius(20)
                    
                    HStack {
                        RankingView(viewModel: viewModel, rank: 1)
                        
                        ZStack {
                            Rectangle()
                                .frame(width: 122, height: 159)
                                .foregroundStyle(.highlightedButton)
                                .cornerRadius(20)
                            
                            RankingView(viewModel: viewModel, rank: 0)
                        }
                        
                        RankingView(viewModel: viewModel, rank: 2)
                    }
                }.padding(27)
                
                Spacer()
                    .frame(height: 90)
                
                ZStack {
                    UsersScrollView(viewModel: viewModel)
                }
              
            }
            .onAppear {
                viewModel.fetchUserInfo()
            }
        }
        .background(.shopSecondary)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LeaderboardView()
}


struct RankingView: View {
    
    @ObservedObject var viewModel: LeaderBoardViewModel
    var rank: Int
    
    var body: some View {
        VStack(spacing: 6) {
            if viewModel.topThreeUser.indices.contains(rank) {
                if let image = viewModel.topThreeUser[rank].image {
                    AsyncImage(url: URL(string: image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFill()
                            .clipped()
                    } placeholder: {
                        Image(systemName: "person.fill")
                    }
                    .frame(width: 82, height: 82)
                    .cornerRadius(50)
                    .offset(y: rank == 0 ? -50 : -25)
                }
                 
                else {
                    Image("person.fill")
                }
                
                let user = viewModel.topThreeUser[rank]
                
                Text(user.username ?? "Username")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text("\(user.points ?? 0)")
                    .foregroundStyle(.gray)
               
            }
            else {
                Text("No user")
            }
        }
    }
}

