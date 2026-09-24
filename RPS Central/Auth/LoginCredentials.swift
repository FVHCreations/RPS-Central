//
//  LoginCredentials.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import Foundation

nonisolated struct LoginCredentials: Equatable, Sendable {
    var email: String
    var password: String

    static func make(email: String, password: String) -> Result<LoginCredentials, LoginValidation> {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if email.isEmpty || password.isEmpty {
            return .failure(.rejected("Enter your email and password."))
        }

        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        let domain = parts.count == 2 ? parts[1] : ""
        if parts.count != 2 || parts[0].isEmpty || domain.isEmpty || !domain.contains(".") {
            return .failure(.rejected("Enter a valid email address."))
        }

        return .success(LoginCredentials(email: email, password: password))
    }
}

nonisolated struct LoginValidation: Equatable, Error {
    var message: String

    static func rejected(_ message: String) -> LoginValidation {
        LoginValidation(message: message)
    }
}
