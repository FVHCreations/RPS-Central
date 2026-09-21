//
//  HubView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct HubView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                subApps
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 32)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("RPS Central")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("RootPulse Solutions")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.accentColor)
            Text("RPS Central")
                .font(.largeTitle.bold())
            Text("Run the business from one place.")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }

    private var subApps: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sub-apps")
                .font(.title2.weight(.semibold))

            VStack(spacing: 12) {
                ForEach(SubAppCatalog.apps) { app in
                    NavigationLink(value: app) {
                        SubAppCard(app: app)
                    }
                    .buttonStyle(.plain)
                }
            }

            Text("Other parts of the business will appear here as their own sub-apps.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
    }
}

private struct SubAppCard: View {
    let app: SubApp

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: app.symbolName)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 52, height: 52)
                .background(
                    Color.accentColor.opacity(0.15),
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(app.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens \(app.name)")
    }
}

#Preview("Hub") {
    NavigationStack {
        HubView()
    }
}
