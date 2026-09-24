//
//  RootView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        Group {
            switch session.gate {
            case .checking:
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        AppCanvas()
                            .backgroundExtensionEffect()
                    }
                    .accessibilityLabel("Loading")
            case .login:
                NavigationStack {
                    LoginView()
                }
            case .hub:
                ContentView()
            }
        }
        .tint(Color("BrandGreen"))
        .task { await session.restore() }
    }
}

enum AppLaunch {
    /// UI tests pass these so they do not read or write the Keychain session.
    static func makeSession() -> AppSession {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-UITestingSignedIn") {
            return .previewSignedIn
        }
        if arguments.contains("-UITestingSignedOut") {
            return .previewSignedOut
        }
        return .live
    }
}

#Preview("Signed out") {
    RootView()
        .environment(AppSession.previewSignedOut)
}

#Preview("Signed in") {
    RootView()
        .environment(AppSession.previewSignedIn)
}
