//
//  TradeButtonView.swift
//  Paper-Stock
//
//  Created by Szymon on 19/11/2026.
//

import SwiftUI

struct TradeButtonsView: View {
    @ObservedObject var viewModel: PlaceOrderViewModel
    @StateObject private var fundsVM = AddFundViewModel()
    @State private var showSheet = false
    var body: some View {
        HStack{
            Button {
                viewModel.selectOrderSide(side: .buy)
                showSheet = true
                Task { await fundsVM.addFunds() }
            } label: {
                Text("Buy")
                    .font(.title2)
                    .frame(width: 150, height: 80)
                    .background(.blue)
                    .cornerRadius(20)
            }
                
            
            Spacer().frame(width: 20)
            Button {
                viewModel.selectOrderSide(side: .sell)
                showSheet = true
            } label: {
                Text("Sell")
                    .font(.title2)
                    .frame(width: 150, height: 80)
                    .background(.blue)
                    .cornerRadius(20)
                    
            }
        }.foregroundStyle(.white)
        .sheet(isPresented: $showSheet) {
            OrderSheetView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    TradeButtonsView(viewModel: PlaceOrderViewModel())
}
