//
//  ChangePasswordViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 24/11/2026.
//

import Foundation
import Combine

@MainActor
class ChangePasswordViewModel: ObservableObject {
    @Published var password = ChangePasswordRequest(oldPassword: "", newPassword: "")
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var canSubmit = false
    private var service = ChangePasswrodService()
    
    var canChange: Bool {
        password.newPassword != password.oldPassword && !password.newPassword.isEmpty && !password.oldPassword.isEmpty
    }
    var min: Bool {
        password.newPassword.count >= 8
    }
    func changePasswrod() async {
        guard canChange else {return}
        isLoading = true
        errorMessage = nil
        defer{isLoading = false}
        
        do {
            try await service.password(oldPassword: password.oldPassword, newPassword: password.newPassword)
            canSubmit = true 
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
