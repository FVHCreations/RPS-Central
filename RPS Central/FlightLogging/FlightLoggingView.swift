//
//  FlightLoggingView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

/// Entrance to the flight-logging sub-app.
struct FlightLoggingView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]

    private let areas: [FlightLogArea] = [
        FlightLogArea(title: "Preflight checks", symbolName: "checkmark.shield"),
        FlightLogArea(title: "Post-flight logs", symbolName: "list.clipboard"),
        FlightLogArea(title: "Maintenance", symbolName: "wrench.and.screwdriver")
    ]

    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 16) {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(areas) { area in
                        AppTile(title: area.title, symbolName: area.symbolName)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollEdgeEffectStyle(.soft, for: .top)
        .background {
            AppCanvas()
                .backgroundExtensionEffect()
        }
        .navigationTitle("Flight logging")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FlightLogArea: Identifiable {
    let title: String
    let symbolName: String

    var id: String { title }
}

#Preview("Flight logging") {
    NavigationStack {
        FlightLoggingView()
    }
}
