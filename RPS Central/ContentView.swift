//
//  ContentView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HubView()
                .navigationDestination(for: SubApp.self) { app in
                    destination(for: app)
                }
        }
        .tint(Color("BrandGreen"))
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
}
