//
//  SupabaseAuthenticator.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import Foundation
import Supabase

final class SupabaseAuthenticator: Authenticator {
    let isConfigured: Bool
    private let client: SupabaseClient?

    init(settings: SupabaseSettings? = SupabaseSettings.load()) {
        isConfigured = settings != nil
        if let settings {
            client = SupabaseClient(
                supabaseURL: settings.url,
                supabaseKey: settings.publishableKey,
                options: SupabaseClientOptions(
                    auth: .init(emitLocalSessionAsInitialSession: true)
                )
            )
        } else {
            client = nil
        }
    }

    func restoreAccount() async -> SignedInAccount? {
        guard let client else { return nil }
        if let session = try? await client.auth.session, !session.isExpired {
            return account(for: session.user, fallbackEmail: "")
        }
        if let session = client.auth.currentSession, !session.isExpired {
            return account(for: session.user, fallbackEmail: "")
        }
        return nil
    }

    func signIn(email: String, password: String) async throws -> SignedInAccount {
        guard let client else {
            throw AuthFailure(message: SupabaseSettings.missingMessage)
        }
        let session = try await client.auth.signIn(email: email, password: password)
        return account(for: session.user, fallbackEmail: email)
    }

    private func account(for user: User, fallbackEmail: String) -> SignedInAccount {
        let email = user.email ?? fallbackEmail
        let stored = user.userMetadata[DisplayName.metadataKey]?.stringValue
        return SignedInAccount(email: email, preferredName: stored)
    }

    func updateDisplayName(_ name: String) async throws -> String {
        guard let client else {
            throw AuthFailure(message: SupabaseSettings.missingMessage)
        }
        let user = try await client.auth.update(
            user: UserAttributes(data: [DisplayName.metadataKey: .string(name)])
        )
        let email = user.email ?? ""
        let stored = user.userMetadata[DisplayName.metadataKey]?.stringValue
        return DisplayName.resolve(email: email, stored: stored ?? name)
    }

    func signOut() async {
        try? await client?.auth.signOut()
    }
}

private struct AuthFailure: LocalizedError {
    var message: String
    var errorDescription: String? { message }
}
