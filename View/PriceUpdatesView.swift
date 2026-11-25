//
//  PriceUpdatesView.swift
//  Paper-Stock
//
//  Created by Szymon on 25/11/2026.
//

import SwiftUI

struct PriceUpdatesView: View {
    let symbol: String
    @StateObject private var service = PriceUpdatesService()

    var body: some View {
        // tu Twój układ, ale dla jednej akcji:
        VStack(alignment: .trailing) {
            if let item = service.data.first {
                Text(String(format: "%.2f", item.price))
                Text(String(format: "%+.2f%%", item.percentageChange))
                    .font(.caption)
                    .foregroundStyle(item.percentageChange >= 0 ? .green : .red)
            }
        }
        .task {
            await service.connect()
            await service.subscribe(symbol: symbol)
        }
        .onDisappear { service.disconnect() }
    }
}

#Preview {
    PriceUpdatesView(symbol: "tsla")
}
