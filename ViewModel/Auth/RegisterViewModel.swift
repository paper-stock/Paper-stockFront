//
//  RegisterViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 02/11/2026.
//

import Foundation
import Combine

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var user = RegisterRequest(email: "", password: "", displayName: "")
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isRegistered = false
    private let service = RegisterService()
    
    var canSubmit: Bool {
        !user.email.isEmpty && !user.password.isEmpty && !user.displayName.isEmpty && !isLoading
    }
    
    func register() async {
        guard canSubmit else { return }
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            try await service.uploadData(email: user.email, password: user.password, displayName: user.displayName)
            isRegistered = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
