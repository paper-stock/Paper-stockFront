//
//  Constants.swift
//  Paper-Stock
//
//  Created by Szymon on 29/07/2026.
//

import Foundation

enum Constants {
    static let baseUrl: String = {
        guard
            let host = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String,
            let scheme = Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String
        else {
            fatalError("Brak API_HOST / API_SCHEME w Info.plist")
        }
        return "\(scheme)://\(host)/api"
    }()
}
