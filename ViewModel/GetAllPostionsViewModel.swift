//
//  GetAllPostionViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 24/11/2026.
//

import Foundation
import Combine

@MainActor
class GetAllPostionsViewModel: ObservableObject {
    @Published var isLoading = false 
    @Published var errorMessage: String?
    @Published var postions: [GetAllPositionsResponse] = []
    private var service = GetAllPositionsService()
    
    func loadPostions() async {
        isLoading = true
        errorMessage = nil
        defer {isLoading = false}
        
        do {
            postions = try await service.loadPostions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
