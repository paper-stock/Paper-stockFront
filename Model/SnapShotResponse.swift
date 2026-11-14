//
//  SnapShotResponse.swift
//  Paper-Stock
//
//  Created by Szymon on 13/11/2026.
//

import Foundation

struct SnapShotResponse: Decodable {
    let symbol: String
    let price: Double
    let amountChange: Double
    let percentageChange: Double
}
