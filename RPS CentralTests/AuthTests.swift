//
//  AuthTests.swift
//  RPS CentralTests
//
//  Created by Floris van Hengel on 24/09/2026.
//

import Foundation
import Testing
@testable import RPS_Central

struct AuthTests {

    @Test func rejectsBlankAndMalformedCredentials() {
        #expect(LoginCredentials.make(email: "  ", password: "") == .failure(.rejected("Enter your email and password.")))
        #expect(LoginCredentials.make(email: "pilot", password: "secret") == .failure(.rejected("Enter a valid email address.")))
        #expect(LoginCredentials.make(email: "pilot@rootpulse", password: "secret") == .failure(.rejected("Enter a valid email address.")))
    }

    @Test func trimsTheEmailAndKeepsThePassword() throws {
        let credentials = try LoginCredentials.make(
            email: "  pilot@rootpulse.example  ",
            password: " secret "
        ).get()
        #expect(credentials == LoginCredentials(email: "pilot@rootpulse.example", password: " secret "))
    }

    @Test func usesTheSupabaseDisplayName() {
        #expect(DisplayName.metadataKey == "Display name")
        #expect(DisplayName.resolve(email: "pilot@rootpulse.example", stored: "  Ada Lovelace  ") == "Ada Lovelace")
        #expect(DisplayName.resolve(email: "pilot@rootpulse.example", stored: nil) == "Pilot")
        #expect(DisplayName.resolve(email: "floris.van.hengel@rootpulse.com", stored: " ") == "Floris Van Hengel")
    }

    @Test func readsOnlyACompleteHttpsProject() {
        #expect(SupabaseSettings.load(from: ["url": "", "publishableKey": ""]) == nil)
        #expect(SupabaseSettings.load(from: [
            "url": "http://example.supabase.co",
            "publishableKey": "sb_publishable_test"
        ]) == nil)

        let settings = SupabaseSettings.load(from: [
            "url": "https://example.supabase.co",
            "publishableKey": " sb_publishable_test "
        ])
        #expect(settings?.url.host == "example.supabase.co")
        #expect(settings?.publishableKey == "sb_publishable_test")
    }

    @Test @MainActor func blankSignInDoesNotCallTheServer() async {
        let authenticator = FakeAuthenticator()
        let session = AppSession(authenticator: authenticator, phase: .signedOut)

        await session.signIn(email: " ", password: "")

        #expect(authenticator.emails.isEmpty)
        #expect(session.gate == .login)
        #expect(session.message == "Enter your email and password.")
    }

    @Test @MainActor func validSignInOpensTheHub() async {
        let authenticator = FakeAuthenticator()
        let session = AppSession(authenticator: authenticator, phase: .signedOut)

        await session.signIn(email: " pilot@rootpulse.example ", password: "secret")

        #expect(authenticator.emails == ["pilot@rootpulse.example"])
        #expect(session.gate == .hub)
        #expect(session.message == nil)
    }

    @Test @MainActor func rejectedSignInStaysOnTheLoginForm() async {
        let authenticator = FakeAuthenticator()
        authenticator.failure = StubAuthError()
        let session = AppSession(authenticator: authenticator, phase: .signedOut)

        await session.signIn(email: "pilot@rootpulse.example", password: "nope")

        #expect(session.gate == .login)
        #expect(session.message == "Invalid login credentials")
    }

    @Test @MainActor func restoreShowsLoginOrTheHub() async {
        let signedOut = AppSession(authenticator: FakeAuthenticator())
        await signedOut.restore()
        #expect(signedOut.gate == .login)

        let authenticator = FakeAuthenticator()
        authenticator.restored = SignedInAccount(email: "pilot@rootpulse.example")
        let signedIn = AppSession(authenticator: authenticator)
        await signedIn.restore()
        #expect(signedIn.gate == .hub)
    }

    @Test @MainActor func restoreDoesNotOverrideAnExistingSession() async {
        let session = AppSession.previewSignedIn
        await session.restore()
        #expect(session.gate == .hub)
    }

    @Test @MainActor func savedDisplayNameUpdatesTheWelcomeName() async throws {
        let authenticator = FakeAuthenticator()
        let session = AppSession(authenticator: authenticator, phase: .signedOut)
        await session.signIn(email: "pilot@rootpulse.example", password: "secret")

        try await session.updateName("  Ada Lovelace  ")

        #expect(authenticator.updatedNames == ["Ada Lovelace"])
        #expect(session.account?.name == "Ada Lovelace")
    }

    @Test @MainActor func blankDisplayNameIsNotSaved() async throws {
        let authenticator = FakeAuthenticator()
        let session = AppSession(authenticator: authenticator, phase: .signedOut)
        await session.signIn(email: "pilot@rootpulse.example", password: "secret")

        try await session.updateName("   ")

        #expect(authenticator.updatedNames.isEmpty)
        #expect(session.account?.name == "Pilot")
    }

    @Test @MainActor func signOutReturnsToLogin() async {
        let authenticator = FakeAuthenticator()
        authenticator.restored = SignedInAccount(email: "pilot@rootpulse.example")
        let session = AppSession(authenticator: authenticator)
        await session.restore()

        await session.signOut()

        #expect(authenticator.didSignOut)
        #expect(session.gate == .login)
    }
}

@MainActor
private final class FakeAuthenticator: Authenticator {
    var isConfigured = true
    var restored: SignedInAccount?
    var emails: [String] = []
    var failure: Error?
    var didSignOut = false
    var updatedNames: [String] = []

    func restoreAccount() async -> SignedInAccount? {
        restored
    }

    func signIn(email: String, password: String) async throws -> SignedInAccount {
        emails.append(email)
        if let failure {
            throw failure
        }
        return SignedInAccount(email: email)
    }

    func signOut() async {
        didSignOut = true
    }

    func updateDisplayName(_ name: String) async throws -> String {
        let stored = name.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedNames.append(stored)
        if let failure {
            throw failure
        }
        return stored
    }
}

private struct StubAuthError: LocalizedError {
    var errorDescription: String? { "Invalid login credentials" }
}
