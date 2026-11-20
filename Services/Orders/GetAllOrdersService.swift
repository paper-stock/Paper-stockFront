//
//  GetAllOrders.swift
//  Paper-Stock
//
//  Created by Szymon on 19/11/2026.
//

import Foundation


class GetAllOrdersService {
    
    func getAllOrders() async throws -> [GetAllOrdersResponse] {
        guard var components = URLComponents(string: "\(Constants.baseUrl)/orders") else {
            throw URLError(.badURL)
        }
        components.queryItems = [URLQueryItem(name: "status", value: "PENDING")]
        
        guard let url = components.url else {
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
            return try JSONDecoder().decode([GetAllOrdersResponse].self, from: data)
        } catch {
            throw URLError(.cannotParseResponse)
        }
        
        }
}
