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
    @Published var order = PlaceOrderRequest(orderSide: .buy, orderType: "MARKET", stockSymbol: "", funds: nil)
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var placedOrder: Bool = false
    private let service = PlaceOrderService()
    
    
    func selectOrderSide(side: OrderSide){
        let selectedSide = side
        order.orderSide = selectedSide
    }
    func order() async {
        isLoading = true
        placedOrder = false
        errorMessage = nil
        
        defer {isLoading = false}
        
        if order.orderSide == .buy {
            guard let funds = order.funds, funds > 0 else {
                errorMessage = "Please enter a valid order amount"
                return
            }
        }
        
//        if order.orderSide == .sell {
//            guard let shares = order.shares =
//        }
        
        do {
            let result = try await service.placeOrder(funds: order.funds, symbol: order.stockSymbol, side: order.orderSide)
            placedOrder = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
