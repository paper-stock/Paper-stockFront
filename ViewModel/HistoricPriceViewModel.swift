//
//  HistoricPriceViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 13/11/2026.
//

import Foundation
import Combine

@MainActor
class HistoricPriceViewModel: ObservableObject {
    @Published var price: HistoryPriceResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var service = HistoryPriceService()
    
    func get(symbol: String) async{
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let result = try await service.getPrice(symbol: symbol)
            price = result
        } catch {
             errorMessage = error.localizedDescription
        }
    }
}
