//
//  LogoView.swift
//  Paper-Stock
//
//  Created by Szymon on 16/11/2026.
//

import SwiftUI

struct LogoView: View {
    let symbol: String
    @State private var logo: UIImage?
    private let service = LogoService()

    var body: some View {
        Group {
            if let logo {
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .frame(width: 40, height: 40)
        .task(id: symbol) {
            logo = try? await service.getLogo(symbol: symbol)
        }
    }
}

#Preview {
    LogoView(symbol: "AAPL")
}
