//
//  ShopViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import Foundation

import NetworkServicePackage

class ShopViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var productsList = [Product]()
    @Published var productCategories = [String]()
    @Published var cartItems = [Product]()
    @Published var couponCodes = ["7mayerrs", "35mm", "Check24", "Tbcxusaid"]

    private let url = "https://mocki.io/v1/d1d6abfb-14d7-40de-a11a-9dc3d93c4ea9"
    
    // MARK: - Fetching Data
    
    func viewAppeared() {
        fetchData() { [weak self] result in
            switch result {
            case .success(let success):
                self?.productsList = success
                let products = success.map( {$0.category} )
                let orderedCategories = products.reduce(into: [String]()) { result, category in
                    if !result.contains(category) {
                        result.append(category)
                    }
                }
                self?.productCategories = orderedCategories
                print(self?.productCategories ?? [Product]())
            case .failure(let failure):
                print("fetching failed. \(failure)")
            }
        }
    }
    
    func checkCouponCode(code: String) -> Bool {
        if couponCodes.contains(code) {
            return true
        } else {
            return false
        }
    }
    
    func fetchData(completion: @escaping (Result<[Product],Error>) ->(Void)){
        NetworkService().getData(urlString: url, completion: completion)
    }
    
    func increaseProductQuantity(for product: Product) {
        addItemToCart(item: product)
        if let index = productsList.firstIndex(where: { $0.id == product.id }) {
            productsList[index].quantity += 1
        }
    }
    
    func decreaseProductQuantity(for product: Product) {
        removeItemFromCart(item: product)
        if let index = productsList.firstIndex(where: { $0.id == product.id }) {
            if productsList[index].quantity > 0 {
                productsList[index].quantity -= 1
            }
        }
    }
    
    func delete(for product: Product) {
        if let index = productsList.firstIndex(where: { $0.id == product.id }) {
            productsList[index].quantity = 0
        }
    }
    
    func calculateTotalQuantity() -> Int {
        var totalQuantity = 0
        
        for product in productsList {
            totalQuantity += product.quantity
        }
        
        return totalQuantity
    }
    
    func calculateTotalPrice() -> Double {
        var totalPrice = 0.0
        
        for product in productsList {
            totalPrice += Double(product.quantity) * product.price
        }
        
        return Double(round(totalPrice * 100) / 100)
    }
    
    func discount() {
        for index in productsList.indices {
            productsList[index].price -= productsList[index].price * 0.2
        }
    }
    
    func formatPrice(for product: Product) -> String {
        
        if productsList.contains(where: { $0.id == product.id }) {
            return String(format: "%.2f", product.price) + "$"
        }
        return "0.0"
    }
    
    var formatedPrice: String {
        String(format: "%.2f", calculateTotalPrice()) + ""
    }
    
    var total: Double {
        if cartItems.count > 0 {
            return cartItems.reduce(0, { $0 + $1.price} )
        } else {
            return 0
        }
    }
    
    func calculateDiscountedTotal(isCodeCorrect: Bool) -> Double {
        let discountRate = 0.2
        let totalPrice = calculateTotalPrice()
        return isCodeCorrect ? totalPrice * (1 - discountRate) : totalPrice
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
        print(cartItems.count)
        
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
}

