//
//  HubView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct HubView: View {
    private let columns = [
        GridItem(.adaptive(minimum: 156, maximum: 200), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 16) {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(SubAppCatalog.apps) { app in
                        NavigationLink(value: app) {
                            AppTile(title: app.name, symbolName: app.symbolName)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.roundedRectangle(radius: 28))
                        .tint(.primary)
                        .accessibilityHint("Opens \(app.name)")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 28)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollEdgeEffectStyle(.soft, for: .top)
        .background {
            AppCanvas()
                .backgroundExtensionEffect()
        }
        .navigationTitle("RPS Central")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image("RootPulseLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                    .accessibilityLabel("RootPulse Solutions")
            }
        }
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
