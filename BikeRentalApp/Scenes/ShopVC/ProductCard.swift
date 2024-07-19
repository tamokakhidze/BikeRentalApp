//
//  ProductCard.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

struct ProductCard: View {
    
    @EnvironmentObject var viewModel: ShopViewModel
    @Binding var product: Product
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .frame(width: 106, height: 106)
                    .cornerRadius(15)
                    .foregroundStyle(.clear)
                
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 106, height: 106)
                .cornerRadius(15)
            }

            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                
                HStack(alignment: .bottom) {
                    Text("\(viewModel.formatPrice(for: product))")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondaryText)
                }
                
                Image("favIcon")
            }.padding(EdgeInsets(top: 19, leading: 14, bottom: 19, trailing: 18))
            
            Spacer()
            
            HStack {
                Button("-")
                {
                    viewModel.decreaseProductQuantity(for: product)
                }
                .frame(width: 30, height: 30)
                .background(.shopSecondary)
                .cornerRadius(8)
                .foregroundColor(.primaryDeep)
                
                
                Text("\(product.quantity)")
                
                Button("+")
                {
                  viewModel.increaseProductQuantity(for: product)
                    //viewModel.addItemToCart(item: product)
                    
                }
                .frame(width: 30, height: 30)
                .background(.shopSecondary)
                .cornerRadius(8)
                .foregroundColor(.primaryDeep)
            }
            
            Spacer()
                .frame(width: 10)
            
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.cellBackground)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 10)
    }
}



extension String {
    func toURL() -> URL {
        URL(string: "https://image.tmdb.org/t/p/w500/\(self)")!
    }
}
