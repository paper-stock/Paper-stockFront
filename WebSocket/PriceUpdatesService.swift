
import Foundation
import Combine

@MainActor
class PriceUpdatesService: ObservableObject {
    @Published var data: [PriceUpdatesResponse] = []
    @Published var isConnected = false

    private var webSocket: URLSessionWebSocketTask?

    func connect() async {
        guard webSocket == nil else { return }
        guard let url = URL(string: "ws://localhost:8080/ws/prices") else { return }

        do {
            let token = try await AuthService.shared.validAccessToken()

            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            webSocket = URLSession.shared.webSocketTask(with: request)
            webSocket?.resume()
            isConnected = true

            Task { await receiveLoop() }
        } catch {
            print("Nie udało się pobrać tokena: \(error)")
        }
    }

    private func receiveLoop() async {
        guard let webSocket else { return }
        do {
            while true {
                let message = try await webSocket.receive()

                if case .string(let text) = message,
                   let jsonData = text.data(using: .utf8) {
                    let updates = try JSONDecoder()
                        .decode([PriceUpdatesResponse].self, from: jsonData)
                    merge(updates)
                }
            }
        } catch {
            isConnected = false
            self.webSocket = nil
        }
    }

    private func merge(_ updates: [PriceUpdatesResponse]) {
        for update in updates {
            if let index = data.firstIndex(where: { $0.symbol == update.symbol }) {
                data[index] = update
            } else {
                data.append(update)
            }
        }
    }

    func subscribe(symbol: String) async {
        let request = PriceUpdatesRequest(command: "subscribe", symbol: symbol)
        guard let jsonData = try? JSONEncoder().encode(request),
              let text = String(data: jsonData, encoding: .utf8) else { return }
        try? await webSocket?.send(.string(text))
    }

    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        isConnected = false
    }
}
