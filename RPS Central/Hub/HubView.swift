//
//  HubView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct HubView: View {
    @Environment(AppSession.self) private var session
    @Binding var isMenuOpen: Bool

    private let columns = [
        GridItem(.adaptive(minimum: 156, maximum: 200), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(welcomeTitle)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)
                    if let email = session.account?.email, !email.isEmpty {
                        Text(email)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Account menu", systemImage: "sidebar.left") {
                    isMenuOpen = true
                }
                .labelStyle(.iconOnly)
            }
        }
        .simultaneousGesture(openMenuGesture)
    }

    private var welcomeTitle: String {
        let name = session.account?.name ?? ""
        return name.isEmpty ? "Welcome" : "Welcome \(name)"
    }

    private var openMenuGesture: some Gesture {
        DragGesture(minimumDistance: 24, coordinateSpace: .local)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                if value.startLocation.x < 28, horizontal > 60, abs(horizontal) > abs(vertical) {
                    isMenuOpen = true
                }
            }
    }
}

#Preview("Hub") {
    @Previewable @State var isMenuOpen = false

    NavigationStack {
        HubView(isMenuOpen: $isMenuOpen)
    }
    .environment(AppSession.previewSignedIn)
}

#Preview("Hub dark") {
    @Previewable @State var isMenuOpen = false

    NavigationStack {
        HubView(isMenuOpen: $isMenuOpen)
    }
    .environment(AppSession.previewSignedIn)
    .preferredColorScheme(.dark)
}
