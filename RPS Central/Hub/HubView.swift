//
//  HubView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct HubView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 148, maximum: 190), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Image("RootPulseLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .accessibilityLabel("RootPulse Solutions")

                LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                    ForEach(SubAppCatalog.apps) { app in
                        NavigationLink(value: app) {
                            AppTile(title: app.name, symbolName: app.symbolName)
                        }
                        .buttonStyle(TileButtonStyle())
                        .accessibilityHint("Opens \(app.name)")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 28)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color("Paper").ignoresSafeArea())
        .navigationTitle("RPS Central")
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview("Hub") {
    NavigationStack {
        HubView()
    }
}

#Preview("Hub dark") {
    NavigationStack {
        HubView()
    }
    .preferredColorScheme(.dark)
}
