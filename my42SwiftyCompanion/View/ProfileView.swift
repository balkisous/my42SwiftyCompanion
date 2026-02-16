//
//  ProfileView.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 29/01/2026.
//

import SwiftUI

struct ProfileView: View {

    let user: UserProfile
    @State var openAllProjects: Bool = false
    
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
                            .font(.titleFont)
                            .bold()
                            .foregroundColor(Colors.titleColor.color)
                        Text(user.email)
                            .font(.bodyMediumFont)
                            .foregroundColor(Colors.foregroundColorText.color)
                        Text("Level \(String(format: "%.1f%%", user.level))")
                            .foregroundColor(Colors.foregroundColorText.color)
                            .font(.bodyMediumFont)
                    }
                }
                
                Divider()
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(icon: "📍", text: user.location ?? "Offline")
                    InfoRow(icon: "💰", text: "Wallet: \(user.wallet) ₳")
                    InfoRow(icon: "⭐", text: "Evaluations points: \(user.correctionPoint)")
                }
                
                Divider()
                
                // Skills
                Text("Skills")
                    .foregroundColor(Colors.titleColor.color)
                    .font(.subheadlineFont)
                
                ForEach(user.skills, id: \.name) { skill in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(skill.name)
                                .foregroundColor(Colors.filedColor.color)
                            Spacer()
                            Text("\(String(format: "%.1f%%", skill.percentage))")
                                .foregroundColor(Colors.foregroundColorGray.color)
                        }
                        .font(.bodyFont)
                        ProgressView(value: skill.percentage, total: 100)
                            .tint(Colors.skillFiledColor.color)
                    }
                }
                
                Divider()
                
                // Projects
                Text("Projects")
                    .font(.subheadlineFont)
                    .foregroundColor(Colors.foregroundColorText.color)
                
                if openAllProjects {
                    ForEach(user.projectsUsers, id: \.id) { project in
                        HStack {
                            let status = user.projectStatus(for: project)
                            Text("\(status) - \(project.project.name)")
                                .foregroundColor(Colors.foregroundColorText.color)
                            Spacer()
                            Text("\(project.finalMark ?? 0)/100")
                                .foregroundColor(Colors.foregroundColorGray.color)
                        }
                        .font(.bodyFont)
                    }
                    
                } else {
                    ForEach(Array(user.projectsUsers.prefix(5))) { project in
                            HStack {
                            let status = user.projectStatus(for: project)
                            Text("\(status) - \(project.project.name)")
                                .foregroundColor(Colors.foregroundColorText.color)
                            Spacer()
                            Text("\(project.finalMark ?? 0)/100")
                                .foregroundColor(Colors.foregroundColorGray.color)
                        }
                        .font(.bodyFont)
                    }
                    
                }
                HStack {
                    Spacer()
                    
                    Button("", systemImage: "chevron.down") {
                        openAllProjects.toggle()
                    }
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
                .font(.bodyFont)
                .foregroundColor(Colors.foregroundColorText.color)
        }
    }
}
