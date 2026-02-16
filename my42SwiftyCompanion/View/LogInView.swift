//
//  ContentView.swift
//  my42SwiftyCompanion
//
//  Created by balkis wang on 09/01/2026.
//

import SwiftUI

struct LogInView: View {
    
    @State private var isError = false
    
    @StateObject private var authManager = Auth42Manager()
    
    var body: some View {
        
        if authManager.isLoading {
            ProgressView("Connecting to your 42Profile...")
                .foregroundColor(Colors.foregroundColorGray.color)
                .font(.subheadlineFont)
        } else if authManager.isAuthenticated, let user = authManager.user {
            VStack {
                ProfileView(user: user)
                
                Button("Log out") {
                    authManager.logout()
                }
                .padding(.horizontal, 60)
                .padding(.vertical, 10)
                .background(Colors.backgroundbuttonColor.color)
                .foregroundColor(Colors.foregroundColorError.color)
                .border(Colors.foregroundButtonColor.color, width: 1)
                .cornerRadius(10)
                .font(.buttonFont)
            }
            
        } else {
            VStack (spacing: 30) {
                
                titleView
                
                Image("42ParisLogo")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .cornerRadius(10)
                
                logInButton
            }
            .padding()
            .alert("Error to Login", isPresented: $authManager.isError) {
                Button("Dismiss", role: .cancel) {
                    authManager.isError = false
                }
                .font(.buttonFont)
            } message: {
                Text(authManager.errorMessage ?? "Unknown Error")
            }
            .tint(.red)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(), value: authManager.isError)
        }
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
        .background(Colors.backgroundbuttonColor.color)
        .foregroundColor(Colors.foregroundButtonColor.color)
        .border(Colors.foregroundButtonColor.color, width: 1)
        .font(.buttonFont)
        .cornerRadius(10)
    }
}

#Preview {
    LogInView()
}
