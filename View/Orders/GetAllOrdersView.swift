//
//  GetAllOrdersView.swift
//  Paper-Stock
//
//  Created by Szymon on 20/11/2026.
//
import SwiftUI

struct GetAllOrdersView: View {
    @StateObject private var viewModel = GetAllOrdersViewModel()

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
                    HStack {
                        Text(order.stockSymbol)
                        Spacer()
                        Text(order.orderStatus)
                        Text(order.createdAtMarketTime)
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
