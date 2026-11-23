//
//  PlaceOrderViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation
import Combine

@MainActor
class PlaceOrderViewModel: ObservableObject {
    @Published var order = PlaceOrderRequest(orderSide: .buy, orderType: "MARKET", stockSymbol: "", funds: nil, shares: nil)
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isSucced: Bool = false
    @Published var placedOrder: Bool = false
    private let service = PlaceOrderService()
    
    
    func selectOrderSide(side: OrderSide){
        let selectedSide = side
        order.orderSide = selectedSide
    }
    func placeOrder() async {
        isLoading = true
        placedOrder = false
        errorMessage = nil
        
        defer {isLoading = false}
        
        switch order.orderSide {
        case .buy:
            guard let funds = order.funds, funds > 0 else {
                errorMessage = "Please enter a valid order amount"
                return
            }
        case .sell:
            guard let shares = order.shares, shares > 0 else {
                errorMessage = "Please enter a valid number of shares"
                return
            }
        }
        
        do {
            let result = try await service.placeOrder(funds: order.funds, symbol: order.stockSymbol, side: order.orderSide, shares: order.shares)
            placedOrder = true
            isSucced = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
