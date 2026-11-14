//
//  HistoryPriceService.swift
//  Paper-Stock
//
//  Created by Szymon on 13/11/2026.
//

import Foundation

class HistoryPriceService {
    func getPrice(symbol: String) async throws -> HistoryPriceResponse {
        guard var component = URLComponents(string: "\(Constants.baseUrl)/stocks/price-history") else {
            throw URLError(.badURL)
        }
        component.queryItems = [URLQueryItem(name: "symbol", value: symbol)]
        
        guard let url = component.url else {
            throw URLError(.badURL)
        }
        
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        do {
            return try JSONDecoder().decode(HistoryPriceResponse.self, from: data)
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
