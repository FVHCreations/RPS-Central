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
            Image(systemName: symbolName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color("BrandGreen"))
                .frame(width: 40, height: 40)
                .background(Color("BrandGreen").opacity(0.16), in: Circle())
                .accessibilityHidden(true)

            Spacer(minLength: 18)

            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement(children: .combine)
    }
}

struct RootPulseMark: View {
    var height: CGFloat = 28

    var body: some View {
        Image("RootPulseLogo")
            .resizable()
            .scaledToFit()
            .frame(height: height, alignment: .leading)
            .accessibilityLabel("RootPulse Solutions")
    }
}

struct AppCanvas: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("Paper")
            LinearGradient(
                colors: [
                    Color("BrandGreen").opacity(0.20),
                    Color("BrandGreen").opacity(0.05),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 360)
        }
        .ignoresSafeArea()
    }
}
