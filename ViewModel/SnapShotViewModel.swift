//
//  SnapShotViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 13/11/2026.
//

import Foundation
import Combine

@MainActor
class SnapShotViewModel: ObservableObject {
    @Published var model: [SnapShotResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var service = SnapShotService()
    
    func lastPrice(symbol: String) async{
        isLoading = true
        errorMessage = nil
        
        defer{ isLoading = false}
        
        do {
            let resault = try await service.getPrice(symbol: symbol)
            model = resault
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
