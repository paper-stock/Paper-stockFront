//
//  LogoService.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//
import Foundation
import UIKit
import SwiftUI


struct LogoService{
    
    func getLogo(symbol: String) async throws -> URL{
        guard let url = URL(string: "\(Constants.baseUrl)/logos/\(symbol)") else {
            throw URLError(.badURL)
        }
        return url
    }
}



