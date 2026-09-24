//
//  SupabaseSettings.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import Foundation

/// Project URL and publishable key from `Supabase.plist`. The secret key never belongs here.
nonisolated struct SupabaseSettings: Equatable, Sendable {
    var url: URL
    var publishableKey: String

    static let missingMessage = "Add the Supabase project URL and publishable key to Supabase.plist to sign in."

    static func load(from dictionary: [String: String]) -> SupabaseSettings? {
        let rawURL = dictionary["url"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let key = dictionary["publishableKey"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let url = URL(string: rawURL),
              url.scheme == "https",
              let host = url.host,
              !host.isEmpty,
              !key.isEmpty
        else {
            return nil
        }
        return SupabaseSettings(url: url, publishableKey: key)
    }

    static func load(bundle: Bundle = Bundle(for: SupabaseBundleToken.self)) -> SupabaseSettings? {
        guard let url = bundle.url(forResource: "Supabase", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let object = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dictionary = object as? [String: Any]
        else {
            return nil
        }

        let strings = dictionary.compactMapValues { $0 as? String }
        return load(from: strings)
    }
}

private final class SupabaseBundleToken {}
