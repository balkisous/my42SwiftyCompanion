//
//  ContentView.swift
//  my42SwiftyCompanion
//
//  Created by balkis wang on 09/01/2026.
//

import SwiftUI

struct LogInView: View {
    
    @StateObject private var authManager = Auth42Manager()
    
    var body: some View {
        
        if authManager.isLoading {
            ProgressView("Connecting to your 42Profile...")
        } else if authManager.isAuthenticated, let user = authManager.user {
            VStack {
                UserProfileView(user: user)
                
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


struct UserProfileView: View {
    let user: UserProfile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Profile Header
                HStack {
                    AsyncImage(url: URL(string: user.profileImage)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(user.login)
                            .font(.title)
                            .bold()
                        Text(user.email)
                            .font(.caption)
                        Text("Level \(String(format: "%.1f", user.level))")
                    }
                }
                
                Divider()
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(icon: "📍", text: user.location ?? "Offline")
                    InfoRow(icon: "💰", text: "Wallet: \(user.wallet)")
                    InfoRow(icon: "⭐", text: "Evaluations: \(user.correctionPoint)")
                    InfoRow(icon: "📱", text: user.phone ?? "N/A")
                }
                
                Divider()
                
                // Skills
                Text("Skills")
                    .font(.headline)
                
                ForEach(user.skills, id: \.name) { skill in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(skill.name)
                            Spacer()
                            Text("\(String(format: "%.1f%%", skill.percentage))")
                                .foregroundColor(.gray)
                        }
                        .font(.subheadline)
                        
                        ProgressView(value: skill.percentage, total: 100)
                            .tint(.blue)
                    }
                }
                
                Divider()
                
                // Projects
                Text("Projects")
                    .font(.headline)
                
                ForEach(user.projectsUsers, id: \.project.name) { project in
                    HStack {
                        Text(project.isPassed ? "✅" : project.isFailed ? "❌" : "⏳")
                        Text(project.project.name)
                        Spacer()
                        Text("\(project.finalMark ?? 0)/100")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                }
            }
            .padding()
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Text(icon)
            Text(text)
        }
    }
}

#Preview {
    LogInView()
}

// redirect URL
// my42SwiftyCompanion://oauth-callback
