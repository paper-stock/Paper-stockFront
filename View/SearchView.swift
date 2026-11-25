import SwiftUI

struct SearchView: View {
    @StateObject var search = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if search.isLoading {
                    ProgressView()
                }
                if let error = search.errorMessage {
                    Text(error)
                }
                if search.searchStocks.isEmpty && !search.searchText.isEmpty && !search.isLoading {
                    Text("No result found")
                }
                List {
                    ForEach(search.searchStocks, id: \.id) { stock in
                        NavigationLink(value: stock) {
                            HStack {
                                LogoView(symbol: stock.symbol)
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
                                PriceUpdatesView(symbol: stock.symbol)
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
        .onChange(of: search.searchText) { _, newValue in
            Task {
                await search.search(q: newValue)
            }
        }
    }
}

#Preview {
    SearchView()
}
