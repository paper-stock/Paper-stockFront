//
//  GetAllPositions.swift
//  Paper-Stock
//
//  Created by Szymon on 24/11/2026.
//

import Foundation

struct GetAllPositionsResponse: Decodable, Identifiable {
    let id: String
    let stockId: String
    let stockSymbol: String
    let shares: Double
    let reservedShares: Double
}

