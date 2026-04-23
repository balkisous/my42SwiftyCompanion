//
//  my42SwiftyCompanionApp.swift
//  my42SwiftyCompanion
//
//  Created by balkis wang on 09/01/2026.
//

import SwiftUI

@main
struct my42SwiftyCompanionApp: App {

    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(
                    colors: Colors.gradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                HomeView()
            }
        }
    }
}
