//
//  ContentView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isMenuOpen = false

    var body: some View {
        ZStack {
            NavigationStack {
                HubView(isMenuOpen: $isMenuOpen)
                    .navigationDestination(for: SubApp.self) { app in
                        destination(for: app)
                    }
            }

            if isMenuOpen {
                AccountSidebar(isPresented: $isMenuOpen)
                    .transition(.move(edge: .leading))
            }
        }
        .tint(Color("BrandGreen"))
        .animation(.smooth(duration: 0.28), value: isMenuOpen)
    }

    @ViewBuilder
    private func destination(for app: SubApp) -> some View {
        switch app.id {
        case SubAppCatalog.flightLogging.id:
            FlightLoggingView()
        default:
            ContentUnavailableView(app.name, systemImage: app.symbolName)
        }
    }
}

#Preview {
    ContentView()
        .environment(AppSession.previewSignedIn)
}
