//
//  GetAllPostionsView.swift
//  Paper-Stock
//
//  Created by Szymon on 24/11/2026.
//

import SwiftUI

struct GetAllPostionsView: View {
    @StateObject private var viewModel = GetAllPostionsViewModel()
    
    var body: some View {
        
        List{
            ForEach(viewModel.postions) { position in
                HStack{
                    LogoView(symbol: position.stockSymbol)
                    Text("\(position.shares)")
                }
            }
            
        }
        .task {await viewModel.loadPostions()}
    }
}

#Preview {
    GetAllPostionsView()
}
