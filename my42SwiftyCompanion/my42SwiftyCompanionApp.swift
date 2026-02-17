//
//  my42SwiftyCompanionApp.swift
//  my42SwiftyCompanion
//
//  Created by balkis wang on 09/01/2026.
//

import SwiftUI

@main
struct my42SwiftyCompanionApp: App {

    @StateObject private var authManager = Auth42Manager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(
                    colors: Colors.gradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                if authManager.isLoading {
                    ProgressView("Connecting to your 42Profile...")
                        .foregroundColor(Colors.foregroundColorGray.color)
                        .font(.subheadlineFont)
                } else if authManager.isAuthenticated, let user = authManager.user {
                    ProfileView(user: user)
                        .environmentObject(authManager)
                } else {
                    LogInView()
                        .environmentObject(authManager)
                }
            }
        }
    }
}
