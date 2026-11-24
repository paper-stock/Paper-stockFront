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
    @Published var isSucceeded: Bool = false
    @Published var isActive: Bool = false 
    @Published var placedOrder: Bool = false
    private let service = PlaceOrderService()
    @Published var orderResponse: PlaceOrderResponse?
    
    
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
                isSucceeded = false
                return
            }
        }
            
            do {
                _ = try await service.placeOrder(funds: order.funds, symbol: order.stockSymbol, side: order.orderSide, shares: order.shares)
                placedOrder = true
                isSucceeded = true
            } catch {
                print(error)
                errorMessage = error.localizedDescription
                isSucceeded = false
            }
        }
    }

