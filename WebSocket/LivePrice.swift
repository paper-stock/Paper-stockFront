//
//  LivePrice.swift
//  Paper-Stock
//
//  Created by Szymon on 29/10/2026.
//

import Foundation

struct LivePriceRequest: Encodable {
    let command: String
    let symbol: String
}
struct LivePriceResponse: Decodable {
    let T: String
    let S: String
    let i: Int
    let x: String
    let p: Double
    let s: Int
    let c: [String]
    let z: String
    let t: String
    
}
