//
//  ProfileView.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 29/01/2026.
//

import SwiftUI

struct ProfileView: View {

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
                    InfoRow(icon: "⭐", text: "Evaluations points: \(user.correctionPoint)")
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
                        let _ = print("project \(project)")
                        let status = user.projectStatus(for: project)
                        Text("\(status) - \(project.project.name)")
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
