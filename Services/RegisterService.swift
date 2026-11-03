//
//  RegisterService.swift
//  Paper-Stock
//
//  Created by Szymon on 02/11/2026.
//

import Foundation

class RegisterService {
    
    func uploadData(email: String, password: String, displayName: String) async throws{
        guard let url = URL(string: "\(Constants.baseUrl)/auth/register") else {
            throw URLError(.badURL)
        }
        
        let body = RegisterRequest(email: email, password: password, displayName: displayName)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
