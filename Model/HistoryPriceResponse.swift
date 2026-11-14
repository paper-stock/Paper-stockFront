//
//  HistoryPriceResponse.swift
//  Paper-Stock
//
//  Created by Szymon on 13/11/2026.
//

import Foundation

struct HistoryPriceResponse: Decodable {
    let symbol: String
    let day: Double
    let week: Double
    let month: Double
    let quarter: Double
    let year: Double
}
