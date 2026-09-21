//
//  FlightLoggingView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

/// Entrance to the flight-logging sub-app.
struct FlightLoggingView: View {
    private let areas: [FlightLogArea] = [
        FlightLogArea(
            title: "Preflight checks",
            detail: "Checks completed before a flight.",
            symbolName: "checkmark.shield"
        ),
        FlightLogArea(
            title: "Post-flight logs",
            detail: "What happened on the flight, recorded after landing.",
            symbolName: "list.clipboard"
        ),
        FlightLogArea(
            title: "Maintenance",
            detail: "Upkeep and service for the aircraft.",
            symbolName: "wrench.and.screwdriver"
        )
    ]

    var body: some View {
        List {
            Section {
                Text("Record a flight from preparation through the work that follows it.")
                    .foregroundStyle(.secondary)
            }

            Section("In this sub-app") {
                ForEach(areas) { area in
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(area.title)
                            Text(area.detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: area.symbolName)
                    }
                }
            }
        }
        .navigationTitle("Flight logging")
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct FlightLogArea: Identifiable {
    let title: String
    let detail: String
    let symbolName: String

    var id: String { title }
}

#Preview("Flight logging") {
    NavigationStack {
        FlightLoggingView()
    }
}
