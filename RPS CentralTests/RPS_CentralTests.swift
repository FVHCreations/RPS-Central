//
//  RPS_CentralTests.swift
//  RPS CentralTests
//
//  Created by Floris van Hengel on 22/09/2026.
//

import Testing
@testable import RPS_Central

struct RPS_CentralTests {

    @Test func hubOpensWithFlightLogging() {
        #expect(SubAppCatalog.apps == [SubAppCatalog.flightLogging])
        #expect(SubAppCatalog.flightLogging.name == "Flight logging")
    }

}
