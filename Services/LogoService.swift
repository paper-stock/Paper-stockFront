//
//  LogoService.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//
import Foundation
import UIKit

struct LogoService{
    func getLogo(symbol: String) async throws -> UIImage{
        guard let url = URL(string: "\(Constants.baseUrl)/logos/\(symbol)") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
}
