//
//  ShopMainView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

struct ShopMainView: View {
    
    @EnvironmentObject var viewModel: ShopViewModel
    @State var couponCode: String = ""
    @State var isCodeCorrect: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            Image("cartImage")
                                .resizable()
                                .frame(width: 35, height: 35)
                            
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.red)
                                .offset(x: 7, y: -7)
                            
                            Text("\(viewModel.cartItems.count)")
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .offset(x: 3, y: -7)
                        }
                    }
                    .padding(.trailing, 20)
                    
                    
                    Text("Shop essentials for your ride")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 157)
                            .foregroundColor(.shopSecondary)
                            .cornerRadius(18)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                        
                        VStack(alignment: .leading) {
                            Text("Have a coupon?")
                                .foregroundStyle(.gray.opacity(1))
                                .fontWeight(.thin)
                            TextField("Enter code", text: $couponCode)
                            
                            Button("Check") {
                                isCodeCorrect = viewModel.checkCouponCode(code: couponCode)
                                print(isCodeCorrect)
                            }
                        }
                        .padding()
                        
                        
                    }
                    
                    Text("New arrivals")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                    
                    ScrollView(.horizontal) {
                        
                        LazyHGrid(rows: [GridItem(.fixed(353))], spacing: 20) {
                            ForEach(Array(viewModel.productCategories), id: \.self) { category in
                                if let product = viewModel.productsList.first(where: {$0.category == category}) {
                                    NavigationLink(destination: ProductsListView(category: category)) {
                                        CategoriesCell(image: product.categoryImage, categoryName: category, startingPrice: 19)
                                            .background(.shopSecondary)
                                            .cornerRadius(18)
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .onAppear {
                    viewModel.viewAppeared()
                }
                .padding(.top, 100)
                .padding(.leading, 24)
                
                
            }
            .background(Color.background).ignoresSafeArea()
            
        }
    }
}

#Preview {
    ShopMainView()
        .environmentObject(ShopViewModel())
}
