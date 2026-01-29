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
        } else if authManager.isAuthenticated, let user = authManager.user {
            VStack {
                ProfileView(user: user)
                
                Button("Log out") {
                    authManager.logout()
                }
                .foregroundColor(.red)
                .buttonStyle(.plain)
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
//            .sheet(isPresented: $authManager.isError , content: {
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        authManager.isError = false
//                    }
//                ErrorPopUpView(title: "Error to Login", subtitle: authManager.errorMessage!) {
//                    authManager.isError.toggle()
//                }
//                .background(Color.white)
//                .cornerRadius(15)
//                .shadow(radius: 20)
//                .padding(40)
//            })
            .alert("Error to Login", isPresented: $authManager.isError) {
                Button("Dismiss", role: .cancel) {
                    authManager.isError = false
                }
            } message: {
                Text(authManager.errorMessage ?? "Unknown error")
            }
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(), value: authManager.isError)
        }
        
    }
    
    var titleView : some View {
        VStack (alignment: .center, spacing: 0) {
            Text("My42SwiftyCompanion")
                .fontWeight(.bold)
                .foregroundColor(Colors.titleColor.color)
                .fontWidth(.standard)
            Text("Your custom 42Profile App")
                .font(.bosaBold)
                .foregroundColor(Colors.titleColor.color)
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
        .cornerRadius(10)
        
    }
    
    
}

#Preview {
    LogInView()
}
