//
//  LivePriceService.swift
//  Paper-Stock
//
//  Created by Szymon on 29/10/2026.
//

import Foundation
import Combine
@MainActor
class LivePriceService: ObservableObject {
    @Published var newestPrice: LivePriceResponse?
    @Published var errorMessage: String?

    private var task: URLSessionWebSocketTask?
    private var listenTask: Task<Void, Never>?
    
    func connect(symbol: String) async throws {
        
        disconnect()
        
        var request = URLRequest(url: URL(string: "ws://localhost:8080/ws/market")!)
        let token = try await AuthService.shared.validAccessToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.webSocketTask(with: request)
        self.task = task
        task.resume()
        
        listenTask = Task {
            do {
                try await subscribe(symbol: symbol)
                try await listen()
            } catch {
                if !Task.isCancelled {
                        errorMessage = error.localizedDescription
                    }
            }
        }
    }
    
    private func subscribe(symbol: String) async throws {
        guard let task = self.task else { return }

        let object = LivePriceRequest(command: "subscribe", symbol: symbol)
        let data = try JSONEncoder().encode(object)
        let json = String(decoding: data, as: UTF8.self)

        try await task.send(.string(json))
    }
    
    private func listen() async throws {
        guard let task = self.task else {return}
        
        while !Task.isCancelled {
            let message = try await task.receive()

            let data: Data
                        switch message {
                        case .string(let text): data = Data(text.utf8)
                        case .data(let d):      data = d
                        @unknown default:       continue
                        }
            print(String(decoding: data, as: UTF8.self))
            
            if let update = try? JSONDecoder().decode(LivePriceResponse.self, from: data) {
                newestPrice = update
            }
        }
    }
    
    func disconnect() {
            listenTask?.cancel()
            task?.cancel(with: .goingAway, reason: nil)
            task = nil
            listenTask = nil
        }
}
