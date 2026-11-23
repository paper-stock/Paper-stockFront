//
//  OrderSheetView.swift
//  Paper-Stock
//
//  Created by Szymon on 19/11/2026.
//

import SwiftUI

struct OrderSheetView: View {
    @ObservedObject var viewModel: PlaceOrderViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("\(viewModel.order.orderSide == .buy ? "Buy" : "Sell") \(viewModel.order.stockSymbol)")
            }
            switch viewModel.order.orderSide {
            case OrderSide.buy:
                TextField("0$", value: $viewModel.order.funds, format: .number)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .font(.title).frame(width: 100, height: 50)
            case OrderSide.sell:
                TextField("Shares", value: $viewModel.order.shares, format: .number)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .font(.title).frame(width: 100, height: 50)
            }
            Button {
                Task { await viewModel.placeOrder()}
            } label: {
                if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Place order")
                            .font(.title2)
                            .frame(width: 150, height: 80)
                            .background(.blue)
                            .cornerRadius(20)
                            .foregroundStyle(.white)
                    }
            }
            .disabled(viewModel.isLoading)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }
            if viewModel.isSucced {
                Text("The order has been placed ")
                    .foregroundStyle(.green)
            }

        }.padding()
        .onChange(of: viewModel.placedOrder) { _, newValue in
            if newValue { dismiss() }
        }
        .onAppear {
            viewModel.errorMessage = nil
            viewModel.placedOrder = false
        }
    
    }
}

#Preview {
    OrderSheetView(viewModel: PlaceOrderViewModel())
}
