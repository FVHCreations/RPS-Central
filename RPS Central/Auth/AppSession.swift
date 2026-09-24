//
//  AppSession.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import Foundation
import Observation

nonisolated struct SignedInAccount: Equatable, Sendable {
    var email: String
    var name: String

    init(email: String, preferredName: String? = nil) {
        self.email = email
        self.name = DisplayName.resolve(email: email, stored: preferredName)
    }
}

nonisolated enum AppGate: Equatable, Sendable {
    case checking
    case login
    case hub
}

protocol Authenticator: Sendable {
    var isConfigured: Bool { get }
    func restoreAccount() async -> SignedInAccount?
    func signIn(email: String, password: String) async throws -> SignedInAccount
    func signOut() async
    func updateDisplayName(_ name: String) async throws -> String
}

@Observable
final class AppSession {
    private(set) var phase: Phase
    private(set) var message: String?
    private(set) var isSubmitting = false
    let isConfigured: Bool

    private let authenticator: any Authenticator
    private var didStartRestore = false

    enum Phase: Equatable {
        case checking
        case signedOut
        case signedIn(SignedInAccount)
    }

    var gate: AppGate {
        switch phase {
        case .checking:
            .checking
        case .signedOut:
            .login
        case .signedIn:
            .hub
        }
    }

    var account: SignedInAccount? {
        if case .signedIn(let account) = phase {
            return account
        }
        return nil
    }

    init(authenticator: any Authenticator, phase: Phase = .checking) {
        self.authenticator = authenticator
        self.isConfigured = authenticator.isConfigured
        self.phase = phase
    }

    func restore() async {
        guard case .checking = phase, !didStartRestore else { return }
        didStartRestore = true
        let account = await authenticator.restoreAccount()
        guard !Task.isCancelled else {
            didStartRestore = false
            return
        }
        phase = account.map(Phase.signedIn) ?? .signedOut
    }

    func signIn(email: String, password: String) async {
        guard !isSubmitting else { return }
        switch LoginCredentials.make(email: email, password: password) {
        case .failure(let validation):
            self.message = validation.message
        case .success(let credentials):
            isSubmitting = true
            defer { isSubmitting = false }
            do {
                let account = try await authenticator.signIn(
                    email: credentials.email,
                    password: credentials.password
                )
                message = nil
                phase = .signedIn(account)
            } catch {
                let description = error.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                message = description.isEmpty ? "Could not sign in." : description
            }
        }
    }

    func signOut() async {
        guard !isSubmitting else { return }
        await authenticator.signOut()
        message = nil
        phase = .signedOut
    }

    func clearMessage() {
        message = nil
    }

    func updateName(_ name: String) async throws {
        guard case .signedIn(var account) = phase else { return }
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let stored = try await authenticator.updateDisplayName(trimmed)
        account.name = stored
        phase = .signedIn(account)
    }
}

extension AppSession {
    static var live: AppSession {
        AppSession(authenticator: SupabaseAuthenticator())
    }

    static var previewSignedOut: AppSession {
        AppSession(authenticator: PreviewAuthenticator(), phase: .signedOut)
    }

    static var previewSignedIn: AppSession {
        let account = SignedInAccount(email: "pilot@rootpulse.example")
        return AppSession(
            authenticator: PreviewAuthenticator(account: account),
            phase: .signedIn(account)
        )
    }
}

final class PreviewAuthenticator: Authenticator {
    let isConfigured: Bool
    private var account: SignedInAccount?

    init(account: SignedInAccount? = nil, isConfigured: Bool = true) {
        self.account = account
        self.isConfigured = isConfigured
    }

    func restoreAccount() async -> SignedInAccount? {
        account
    }

    func signIn(email: String, password: String) async throws -> SignedInAccount {
        let account = SignedInAccount(email: email)
        self.account = account
        return account
    }

    func signOut() async {
        account = nil
    }

    func updateDisplayName(_ name: String) async throws -> String {
        let stored = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if var account {
            account.name = stored
            self.account = account
        }
        return stored
    }
}
