//
//  RentHistoryCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import SwiftUI

struct RentHistoryCell: View {
    
    var bike: String
    var totalPrice: Double
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 11) {
                    Text(bike)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text(String(format: "%.2f$", totalPrice))
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                }.frame(width: 170, height: 70)
                
                Spacer()
                
                Image(systemName: "arrow.forward.circle")
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
            }
            
            Divider()
                .frame(height: 1)
                .background(.gray.opacity(0.5))
        }.padding(.leading)
            .padding(.trailing)

    }
}

#Preview {
    RentHistoryCell(bike: "Mountain Bike", totalPrice: 12.39)
}
