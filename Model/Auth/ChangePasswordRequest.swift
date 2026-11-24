//
//  ChangePasswordRequest.swift
//  Paper-Stock
//
//  Created by Szymon on 24/11/2026.
//

import Foundation

struct ChangePasswordRequest: Codable {
    var oldPassword: String
    var newPassword: String
}
