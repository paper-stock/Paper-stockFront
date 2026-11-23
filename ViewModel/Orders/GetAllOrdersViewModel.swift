//
//  GetAllOrdersViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 20/11/2026.
//

import Foundation
import Combine

@MainActor
class GetAllOrdersViewModel: ObservableObject {
    @Published var getData: [GetAllOrdersResponse] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private let service = GetAllOrdersService()
    
    func displayOrders() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false}
        
        do {
            getData = try await service.getAllOrders()
            
        } catch {
            errorMessage = error.localizedDescription
        }
    
    }
}
