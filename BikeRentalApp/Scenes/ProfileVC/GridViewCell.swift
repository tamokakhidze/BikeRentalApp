//
//  GridViewCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import SwiftUI

struct GridCellView: View {
    var imageUrl: String
    var price: Double

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                case .failure:
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                @unknown default:
                    EmptyView()
                }
            }
            Text(String(format: "%.2f$", price))
                .font(.caption)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 10)
        .padding(5)
        .frame(width: 136, height: 89)
    }
}

#Preview {
    GridCellView(imageUrl: "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg", price: 5.4)
}
