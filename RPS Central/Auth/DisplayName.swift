//
//  DisplayName.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import Foundation

/// The name shown on the home screen. Supabase stores it in user metadata under ``metadataKey``.
nonisolated enum DisplayName {
    static let metadataKey = "Display name"

    static func resolve(email: String, stored: String?) -> String {
        let stored = stored?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !stored.isEmpty {
            return stored
        }
        let derived = derived(from: email)
        return derived.isEmpty ? "there" : derived
    }

    static func derived(from email: String) -> String {
        let local = email.split(separator: "@", maxSplits: 1).first.map(String.init) ?? ""
        let words = local.split { character in
            character == "." || character == "_" || character == "-" || character == "+"
        }
        return words.map { part in
            let lower = part.lowercased()
            return lower.prefix(1).uppercased() + lower.dropFirst()
        }.joined(separator: " ")
    }
}
