//
//  RPS_CentralApp.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

@main
struct RPS_CentralApp: App {
    @State private var session = AppLaunch.makeSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
        }
    }
}
