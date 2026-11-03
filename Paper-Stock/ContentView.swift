//
//  ContentView.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var service = LivePriceService()
    let symbol = "TSLA"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(service.newestPrice?.p ?? 0)")
        }
        .padding()
        .task {
            do { try await service.connect(symbol: symbol) }
            catch { service.errorMessage = error.localizedDescription }
        }
    }
        
}

#Preview {
    ContentView()
}
