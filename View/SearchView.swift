//
//  SearchView.swift
//  Paper-Stock
//
//  Created by Szymon on 27/10/2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject var search = SearchViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                if search.isLoading {
                    ProgressView()
                }
                if let error = search.errorMessage {
                    Text(error)
                }
                if search.searchStocks.isEmpty && !search.searchText.isEmpty  && search.isLoading == false{
                    Text("No resault found")
                }
                List{
                    ForEach(search.searchStocks, id: \.id) { stock in
                        NavigationLink(value: stock){
                            HStack{
                                AsyncImage(url: URL(string: stock.logoUrl)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(stock.symbol)
                                        .font(.headline)
                                    Text(stock.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                    Text(stock.exchange)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                        }
                    }
                }
                .navigationDestination(for: SearchResponse.self) { response in
                    StockDetailView(response: response)
                }
            }
            .searchable(
                text: $search.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Szukaj spółki, np. TSLA"
            )
        }
        .onChange(of: search.searchText){
            Task{
                await search.search(q: search.searchText)
            }
        }
    }
}

#Preview {
    SearchView()
}
