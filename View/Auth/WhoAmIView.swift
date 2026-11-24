//
//  WhoAmIView.swift
//  Paper-Stock
//
//  Created by Szymon on 31/10/2026.
//

import SwiftUI

struct WhoAmIView: View {
    @StateObject private var viewModel = WhoAmIViewModel()
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
            } else if let user = viewModel.user {
                Text(user.displayName)
                Text(user.email)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    WhoAmIView()
}
