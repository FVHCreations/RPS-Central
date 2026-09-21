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
        GridItem(.adaptive(minimum: 148, maximum: 190), spacing: 14)
    ]

    private let areas: [FlightLogArea] = [
        FlightLogArea(title: "Preflight checks", symbolName: "checkmark.shield"),
        FlightLogArea(title: "Post-flight logs", symbolName: "list.clipboard"),
        FlightLogArea(title: "Maintenance", symbolName: "wrench.and.screwdriver")
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                ForEach(areas) { area in
                    AppTile(title: area.title, symbolName: area.symbolName)
                }
            }
            .padding(20)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color("Paper").ignoresSafeArea())
        .navigationTitle("Flight logging")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("Paper"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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
