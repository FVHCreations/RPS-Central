//
//  SubApp.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import Foundation

/// One area of the business inside RPS Central.
nonisolated struct SubApp: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let summary: String
    let symbolName: String
}

nonisolated enum SubAppCatalog {
    static let flightLogging = SubApp(
        id: "flight-logging",
        name: "Flight logging",
        summary: "Preflight checks, post-flight logs, and maintenance.",
        symbolName: "airplane"
    )

    /// Sub-apps shown on the hub, in display order.
    static let apps: [SubApp] = [flightLogging]
}
