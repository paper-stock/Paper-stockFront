//
//  RegisterView.swift
//  Paper-Stock
//
//  Created by Szymon on 02/11/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    var body: some View {
        VStack{
            Form {
                TextField("Name", text: $viewModel.user.displayName)
                
                TextField("Email", text: $viewModel.user.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.user.password)
                
            }
            
            if let message = viewModel.errorMessage {
                Text(message)
                    .textInputAutocapitalization(.never)
            }
           if viewModel.isLoading {
                ProgressView()
            }
            if viewModel.isRegistered {
                Text("Rejestracja udana")
                    .foregroundStyle(.green)
            }
            
            
                Button("Register"){
                    Task {await viewModel.register()}
                }
                .disabled(!viewModel.canSubmit)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
            }
        
    }
        
}

#Preview {
    RegisterView()
}
