//
//  AddFundsRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation
import Combine
struct AddFundsRequest: Codable {
    let amount: Double
}


class AddFundsService {
    func getFund() async throws {
        guard let url = URL(string: "\(Constants.baseUrl)/app-users/add-funds") else {
            throw URLError(.badURL)
        }
        let body = AddFundsRequest(amount: 500)
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return
    }
}


@MainActor
class AddFundViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var didSucceed = false
    
    private let service = AddFundsService()
    
    func addFunds() async {
        isLoading = true
        didSucceed = false
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await service.getFund()
            didSucceed = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
