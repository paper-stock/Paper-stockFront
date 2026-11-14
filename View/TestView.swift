//
//  TestView.swift
//  Paper-Stock
//
//  Created by Szymon on 13/11/2026.
//

import SwiftUI

struct TestView: View {
    @StateObject private var historicViewModel = HistoricPriceViewModel()
    @StateObject private var snapShot = SnapShotViewModel()

    var body: some View {
        VStack(spacing: 8) {
            if let price = historicViewModel.price, let snapPrice = snapShot.model.first {
                let difference = price.day - snapPrice.price
                Text("\(price.day)")
                Text("\(snapPrice.price)")
                Text("\(difference)")
            } else {
                Text("brak danych")
            }
            
            // diagnostyka
            Text("historia: \(historicViewModel.price == nil ? "nil" : "jest")")
            Text("historia błąd: \(historicViewModel.errorMessage ?? "brak")")
            Text("snapshot: \(snapShot.model.count) elementów")
            Text("snapshot błąd: \(snapShot.errorMessage ?? "brak")")
        }
        .task {
            await historicViewModel.get(symbol: "TSLA")
            await snapShot.lastPrice(symbol: "TSLA")
        }
        
    }
}
        


#Preview {
    TestView()
}
