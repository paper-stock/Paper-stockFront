//
//  WhoAmIModel.swift
//  Paper-Stock
//
//  Created by Szymon on 31/10/2026.
//

import Foundation

struct WhoAmIModelResponse: Decodable {
    let id: String
    let appUserId: String
    let email: String
    let role: String
    let enabled: Bool 
}
