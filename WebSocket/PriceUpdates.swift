//
//  PriceUpdates.swift
//  Paper-Stock
//
//  Created by Szymon on 25/11/2026.
//

import Foundation

struct PriceUpdatesRequest: Encodable {
    let command: String
    let symbol: String
}

struct PriceUpdatesResponse: Decodable, Identifiable {
    
    var id: String {symbol}
    let symbol: String
    let price: Double
    let amountChange: Double
    let percentageChange: Double
}
