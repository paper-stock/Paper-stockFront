//
//  PlaceOrderService.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation

class PlaceOrderService {
    func placeOrder(funds: Double?, symbol: String, side: OrderSide, shares: Double?) async throws -> PlaceOrderResponse{
        guard let url = URL(string: "\(Constants.baseUrl)/orders") else {
            throw URLError(.badURL)
        }
        
        let body = PlaceOrderRequest(orderSide: side, orderType: "MARKET", stockSymbol: symbol, funds: funds, shares: shares)
        
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(PlaceOrderResponse.self, from: data)
    }
}
