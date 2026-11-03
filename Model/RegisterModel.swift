//
//  RegisterModel.swift
//  Paper-Stock
//
//  Created by Szymon on 02/11/2026.
//

import Foundation

struct RegisterRequest: Encodable {
    var email: String
    var password: String
    var displayName: String
}

//struct RegisterResponse: Decodable {
//    let id: String
//    let appUserId: String
//    let email: String
//    let role: String
//    let enabled: Bool
//}
