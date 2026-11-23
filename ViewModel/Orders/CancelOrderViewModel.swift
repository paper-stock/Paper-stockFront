////
////  CancelOrderViewModel.swift
////  Paper-Stock
////
////  Created by Szymon on 16/11/2026.
////
//
//import Foundation
//import Combine
//
//@MainActor
//class CancelOrderViewModel: ObservableObject {
//    @Published private var model: CancelOrderResponse
//    @Published private var isLoading: Bool = false
//    @Published private var errorMessage: String?
//    private let service = CancelOrderService()
//    
//    func cancel() async{
//        isLoading = true
//        errorMessage = nil
//        
//        defer {isLoading = false}
//        
//        do{
//            let result = try await service.cancelConnection()
//            model = result
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
//}
