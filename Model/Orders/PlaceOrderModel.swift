//
//  PlaceOrderModel.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation


enum OrderSide: String, Codable {
    case buy = "BUY"
    case sell = "SELL"
}

extension OrderSide: Identifiable {
    var id: String { rawValue }
}

struct PlaceOrderRequest: Encodable {
    var orderSide: OrderSide
    let orderType: String
    var stockSymbol: String
    var funds: Double?
    var shares: Double? = nil
    var limitPrice: Double? = nil
    var stopPrice: Double? = nil
}

struct PlaceOrderResponse: Decodable {
    let id: String
    let appUserId: String
    let orderSide: OrderSide
    let orderType: String
    let orderStatus: String
    let stockId: String
    let stockSymbol: String
    let reservedFunds: Double
    let refundedFunds: Double?
    let reservedShares: Double?
    let limitPrice: Double?
    let stopPrice: Double?
    let createdAtMarketTime: Date
    let triggeredAt: Date?
  
}
