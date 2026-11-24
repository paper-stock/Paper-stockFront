//
//  WhoAmIViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 31/10/2026.
//

import Foundation
import Combine

@MainActor
class WhoAmIViewModel: ObservableObject {
    @Published var user: WhoAmIModelResponse?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private let service = WhoAmIService()
    
    func load() async {
        defer { isLoading = false}
        
        isLoading = true
        errorMessage = nil
        
        do {
           user = try await service.getUser()
        } catch {
             errorMessage = error.localizedDescription
             user = nil
        }
    }
    
}
