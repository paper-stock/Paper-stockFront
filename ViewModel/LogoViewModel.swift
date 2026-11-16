//
//  LogoViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import Foundation
import Combine
import UIKit

@MainActor
 final class LogoViewModel: ObservableObject {
     @Published var errorMessage: String?
     @Published var isLoading: Bool = false
     @Published var logo: UIImage?
     
    private var service = LogoService()
     
     func logo(symbol: String) async{
         isLoading = true
         errorMessage = nil
         
         defer { isLoading = false}
         
         do{
             let result = try await service.getLogo(symbol: symbol)
             logo = result
         } catch {
             errorMessage = error.localizedDescription
         }
     }
}
