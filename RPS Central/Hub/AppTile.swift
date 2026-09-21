//
//  AppTile.swift
//  RPS Central
//
//  Created by Floris van Hengel on 22/09/2026.
//

import SwiftUI

struct AppTile: View {
    let title: String
    let symbolName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color("BrandGreen")
                .frame(height: 4)

            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: symbolName)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(Color("BrandGreen"))
                    .accessibilityHidden(true)
                Spacer(minLength: 12)
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .aspectRatio(1, contentMode: .fit)
        .background(Color("Ink"))
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

struct TileButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
