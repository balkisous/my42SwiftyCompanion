//
//  ContentView.swift
//  my42SwiftyCompanion
//
//  Created by balkis wang on 09/01/2026.
//

import SwiftUI

struct LogInView: View {
    
    @State private var isError = false
    
    @EnvironmentObject private var authManager: Auth42Manager
    
    var body: some View {
        
        VStack (spacing: 30) {
            
            titleView
            
            Image("42ParisLogo")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .cornerRadius(10)
            
            logInButton
            
        }
        .padding()
    }
    
    var titleView : some View {
        VStack (alignment: .center, spacing: 0) {
            Text("My42SwiftyCompanion")
                .fontWeight(.bold)
                .foregroundColor(Colors.titleColor.color)
                .font(.largeTitleFont)
            Text("Your custom 42Profile App")
                .font(.bodyMediumFont)
                .foregroundColor(Colors.foregroundColorText.color)
        }
    }
    
    var logInButton: some View {
        Button("Log In via 42 Account") {
            authManager.authenticate()
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 10)
        .font(.buttonFont)
        .foregroundColor(Colors.foregroundButtonColor.color)
        .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Colors.backgroundbuttonColor.color)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.foregroundButtonColor.color, lineWidth: 1)
                    )
            )
    }
}

#Preview {
    LogInView()
}
