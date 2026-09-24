//
//  AccountSidebar.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import SwiftUI
import UIKit

struct AccountSidebar: View {
    @Binding var isPresented: Bool
    @Environment(AppSession.self) private var session

    @State private var draft = ""
    @State private var isSaving = false
    @State private var saveMessage: String?

    var body: some View {
        let insets = ScreenObstruction.insets
        GeometryReader { proxy in
            let width = min(340, proxy.size.width * 0.86)
            ZStack(alignment: .leading) {
                Button(action: close) {
                    Color.black.opacity(0.28)
                        .ignoresSafeArea()
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close account menu")

                panel
                    .padding(.top, insets.top + 8)
                    .padding(.bottom, insets.bottom)
                    .padding(.leading, insets.left)
                    .frame(width: width, alignment: .leading)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .background {
                        sidebarShape
                            .glassEffect(.regular, in: sidebarShape)
                            .ignoresSafeArea()
                    }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            draft = session.account?.name ?? ""
        }
    }

    private var panel: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .center) {
                RootPulseMark(height: 40)
                    .frame(maxWidth: 220, alignment: .leading)
                Spacer(minLength: 12)
                Button("Close", systemImage: "xmark") {
                    close()
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.glass)
                .accessibilityLabel("Close account menu")
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(session.account?.name ?? "")
                    .font(.title2.bold())
                Text(session.account?.email ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Display name")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("Display name", text: $draft)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                Text("Shown on the home screen and saved to your account.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let saveMessage {
                Text(saveMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button(action: save) {
                Group {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Save")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.roundedRectangle(radius: 22))
            .controlSize(.large)
            .disabled(isSaving || draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Button {
                Task { await session.signOut() }
            } label: {
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.roundedRectangle(radius: 22))
            .controlSize(.large)
            .tint(.red)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private enum ScreenObstruction {
        static var insets: UIEdgeInsets {
            let scene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
            let window = scene?.keyWindow ?? scene?.windows.first
            return window?.safeAreaInsets ?? UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0)
        }
    }

    private var sidebarShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 32,
            topTrailingRadius: 32
        )
    }

    private func close() {
        saveMessage = nil
        isPresented = false
    }

    private func save() {
        Task {
            isSaving = true
            defer { isSaving = false }
            do {
                try await session.updateName(draft)
                saveMessage = nil
            } catch {
                let description = error.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                saveMessage = description.isEmpty ? "Could not save your display name." : description
            }
        }
    }
}
