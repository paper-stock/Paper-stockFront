//
//  StockDetailView.swift
//  Paper-Stock
//
//  Created by Szymon on 27/10/2026.
//

import SwiftUI

struct StockDetailView: View {
    let response: SearchResponse
    @StateObject private var service = LivePriceService()
    var body: some View {
        VStack{
            HStack(spacing: 20){
                AsyncImage(url: URL(string: response.logoUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .cornerRadius(8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(response.symbol)
                        .font(.headline)
                    Text(response.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    Text(response.exchange)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let price = service.newestPrice?.p {
                    Text(price, format: .currency(code: "USD"))
                        .font(.title2)
                } else {
                    ProgressView()
                }
                    
            }
            
            CandlesView(symbol: response.symbol)
                .frame(height: 400)
        }
        .task {
            do { try await service.connect(symbol: response.symbol) }
            catch { service.errorMessage = error.localizedDescription }
        }
        .onDisappear {
            service.disconnect()
        }
    }
}

#Preview {
    StockDetailView(response: SearchResponse(id: "test-id", stockClass: "us_equity", exchange: "NASDAQ", symbol: "TEST", name: "Test Inc", status: "Active", tradable: true, logoUrl: "Url"))
}
