//
//  GetAllOrdersView.swift
//  Paper-Stock
//
//  Created by Szymon on 20/11/2026.
//
import SwiftUI

struct GetAllOrdersView: View {
    @StateObject private var viewModel = GetAllOrdersViewModel()
    @StateObject private var cancelModel = CancelOrderViewModel()
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Ładowanie...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                    Button("Spróbuj ponownie") {
                        Task { await viewModel.displayOrders() }
                    }
                }
                .padding()
            } else if viewModel.getData.isEmpty {
                Text("Brak zleceń")
                    .foregroundStyle(.secondary)
            } else {
                List(viewModel.getData) { order in
                    HStack{
                        LogoView(symbol: order.stockSymbol)
                        VStack(alignment: .leading, spacing: 2){
                            Text(order.stockSymbol)
                                .font(.headline)
                        }
                        Text(order.orderStatus)
                        Text(order.orderSide)
                            .font(.subheadline)
//                        Spacer().frame(width: 100)
                        VStack{
                            
                            Text(order.createdAtMarketTime, format: .dateTime
                                .hour()
                                .minute())
                            
                            Text(order.createdAtMarketTime, format: .dateTime
                                .day(.twoDigits)
                                .month(.twoDigits)
                                .year(.twoDigits))
                                
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false){
                        if order.orderStatus == "PENDING"{
                            Button(role: .destructive) {
                                Task{await cancelModel.cancel(id: order.id)}
                            } label: {
                                Text("Cancel")
                                    
                            }.tint(.red)
                        }
                    }
                }
                
            }
        }
        .task {
            await viewModel.displayOrders()
        }
    }
}

#Preview {
    GetAllOrdersView()
}
