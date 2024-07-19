//
//  ProductsListView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

struct ProductsListView: View {
    
    var category: String
    @EnvironmentObject var viewModel: ShopViewModel
    @State var showPopup: Bool = false
    @State var couponCode: String = ""
    @State var isCodeCorrect: Bool = false
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            VStack {
                
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach($viewModel.productsList) { $product in
                            ProductCard(product: $product)
                        }
                    }
                    .padding()
                }
                                
                Footer(showPopup: $showPopup, isCodeCorrect: $isCodeCorrect)
                
            }
            .environmentObject(viewModel)
            
            if showPopup {
                CustomPopupView(showPopup: $showPopup, couponCode: $couponCode, viewModel: viewModel, isCodeCorrect: $isCodeCorrect)
                    .transition(.opacity)
                    .animation(.easeOut, value: showPopup)
            }
            
        }.onAppear {
            viewModel.viewAppeared()
        }.navigationTitle(category)
    }
}

#Preview {
    ProductsListView(category: "Helmets")
        .environmentObject(ShopViewModel())
}

