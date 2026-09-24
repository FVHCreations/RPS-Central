//
//  LoginView.swift
//  RPS Central
//
//  Created by Floris van Hengel on 24/09/2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppSession.self) private var session
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focus: Field?

    private enum Field: Hashable {
        case email
        case password
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RootPulseMark(height: 40)
                    .frame(maxWidth: 240, alignment: .leading)

                GlassEffectContainer(spacing: 16) {
                    VStack(spacing: 12) {
                        glassField {
                            TextField("Email", text: $email)
                                .textContentType(.username)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .focused($focus, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { focus = .password }
                        }

                        glassField {
                            SecureField("Password", text: $password)
                                .textContentType(.password)
                                .focused($focus, equals: .password)
                                .submitLabel(.go)
                                .onSubmit { submit() }
                        }
                    }
                }

                if !session.isConfigured {
                    Text(SupabaseSettings.missingMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let message = session.message {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("loginMessage")
                }

                Button(action: submit) {
                    Group {
                        if session.isSubmitting {
                            ProgressView()
                        } else {
                            Text("Sign in")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.roundedRectangle(radius: 28))
                .controlSize(.large)
                .tint(Color("BrandGreen"))
                .disabled(session.isSubmitting)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 28)
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollEdgeEffectStyle(.soft, for: .top)
        .background {
            AppCanvas()
                .backgroundExtensionEffect()
        }
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: email) { session.clearMessage() }
        .onChange(of: password) { session.clearMessage() }
        .disabled(session.isSubmitting)
    }

    private func glassField<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .textFieldStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func submit() {
        Task { await session.signIn(email: email, password: password) }
    }
}

#Preview("Login") {
    NavigationStack {
        LoginView()
    }
    .environment(AppSession.previewSignedOut)
}

#Preview("Login dark") {
    NavigationStack {
        LoginView()
    }
    .environment(AppSession.previewSignedOut)
    .preferredColorScheme(.dark)
}
