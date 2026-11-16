//
//  CancelOrderService.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation

class CancelOrderService {
    func cancelConnection() async throws -> CancelOrderResponse{
        guard let url = URL(string: "\(Constants.baseUrl)/orders/cancel") else {
            throw URLError(.badURL)
        }
        
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.setValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode(CancelOrderResponse.self, from: data)
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
