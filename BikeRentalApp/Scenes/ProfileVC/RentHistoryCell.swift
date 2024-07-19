//
//  RentHistoryCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import SwiftUI

struct RentHistoryCell: View {
    
    var number: Int
    var totalPrice: Double
    var startTime: Date
    var endTime: Date
    var isRentEnded: Bool = false
    var rateAction: () -> Void
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 11) {
                    Text("Bike number: \(number)")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .bold()
                    
                    Text(String(format: "%.2f$", totalPrice))
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                    Text("\(startTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                    Text("\(endTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                }.frame(width: 170)
                
                Spacer()
                
                if isRentEnded {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Image(systemName: "star.bubble")
                            .foregroundColor(.yellow)
                            .frame(width: 32, height: 32)
                    }
                } else {
                    Image(systemName: "star.slash.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
            }
            
            Divider()
                .frame(height: 1)
                .background(Color.gray.opacity(0.5))
        }
        .alert(isPresented: $isPresented) {
            Alert(
                title: Text("Rate"),
                message: Text("Would you like to rate this bike?"),
                
                primaryButton: .default(Text("Send"), action: rateAction),
                secondaryButton: .cancel()
            )
        }
    }
}


#Preview {
    RentHistoryCell(number: 2, totalPrice: 3.9, startTime: Date.now, endTime: Date.now, isRentEnded: true, rateAction: {}).background(.black)
}
