//
//  GetAllOrdersModel.swift
//  Paper-Stock
//
//  Created by Szymon on 20/11/2026.
//

import Foundation

struct GetAllOrdersResponse: Decodable, Identifiable{
    let id: String
    let appUserId: String
    let orderSide: String
    let orderType: String
    let orderStatus: String
    let stockId: String
    let stockSymbol: String
    let reservedFunds: Double 
    let refundedFunds: Double? 
    let reservedShares: Double?
    let limitPrice: Double?
    let stopPrice: Double?
    let createdAtMarketTime: String
    let triggeredAt: String?
}

