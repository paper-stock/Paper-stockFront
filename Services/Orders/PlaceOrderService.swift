//
//  PlaceOrderService.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation

class PlaceOrderService {
    func placeOrder(funds: Double?, symbol: String, side: OrderSide) async throws{
        guard let url = URL(string: "\(Constants.baseUrl)/orders") else {
            throw URLError(.badURL)
        }
        
        let body = PlaceOrderRequest(orderSide: side, orderType: "MARKET", stockSymbol: symbol, funds: funds)
        
        var request = URLRequest(url: url)
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return
    }
}
