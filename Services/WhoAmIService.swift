//
//  WhoAmIService.swift
//  Paper-Stock
//
//  Created by Szymon on 31/10/2026.
//

import Foundation


class WhoAmIService {

    func getUser() async throws -> WhoAmIModelResponse {
        guard let url = URL(string: "\(Constants.baseUrl)/auth/whoami") else {
            throw URLError(.badURL)}
        
        let token = try await AuthService.shared.validAccessToken()
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) =  try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode(WhoAmIModelResponse.self, from: data)
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
