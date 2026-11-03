//
//  SearchViewModel.swift
//  Paper-Stock
//
//  Created by Szymon on 27/10/2026.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchStocks: [SearchResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    private let service = SearchService()
    
    func search(q: String) async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
           let result = try await service.getSearch(q: q)
            searchStocks = result
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
