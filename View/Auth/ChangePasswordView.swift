//
//  ChangePasswordView.swift
//  Paper-Stock
//
//  Created by Szymon on 24/11/2026.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel = ChangePasswordViewModel()
    var body: some View {
        VStack(spacing: 10){
            SecureField("Old password", text: $viewModel.password.oldPassword)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            SecureField("New password", text: $viewModel.password.newPassword)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            if let message = viewModel.errorMessage {
                Text(message)
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if viewModel.canSubmit {
                Text("Password has been changed")
            }
            Button("Change password") {
                Task {await viewModel.changePasswrod()}
            }
            .disabled(!viewModel.canChange)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
        }
        .padding(10)
       
        
    }
}

#Preview {
    ChangePasswordView()
}
