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
    @EnvironmentObject var authManager: Auth42Manager
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Profile Header
                    self.headerProfile
                    
                    Divider()
                    
                    // Info
                    self.userInfos
                    
                    Divider()
                    
                    // Skills
                    self.userSkills
                    
                    Divider()
                    
                    // Projects
                    self.userProjects
                }
                .padding()
            }
            Button("Log out") {
                authManager.logout()
            }
            .font(.buttonFont)
            .padding(.horizontal, 60)
            .padding(.vertical, 10)
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
}

extension ProfileView {
    
    // ---------------------- Header ----------------------

    var headerProfile: some View {
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
    }

    // ---------------------------------------------------
    
    // ---------------------- Infos ----------------------

    var userInfos: some View {
        VStack(alignment: .leading, spacing: 8) {
            InfoRow(icon: "📍", text: user.location ?? "Offline")
            InfoRow(icon: "💰", text: "Wallet: \(user.wallet) ₳")
            InfoRow(icon: "⭐", text: "Evaluations points: \(user.correctionPoint)")
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
    
    // ---------------------------------------------------
    
    var userSkills : some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skills")
                .foregroundColor(Colors.titleColor.color)
                .font(.subheadlineFont)
            
            ForEach(user.skills, id: \.name) { skill in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(skill.name)
                            .foregroundColor(Colors.skillFiledColor.color)
                        Spacer()
                        Text("\(String(format: "%.1f%%", skill.percentage))")
                            .foregroundColor(Colors.foregroundColorGray.color)
                    }
                    .font(.bodyFont)
                    ProgressView(value: skill.percentage, total: 100)
                        .tint(Colors.skillFiledColor.color)
                }
            }
        }
    }

    // ---------------------- Projects ----------------------
    var userProjects : some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projects")
                .foregroundColor(Colors.foregroundColorText.color)
                .font(.subheadlineFont)
            
            if openAllProjects {
                ForEach(user.projectsUsers, id: \.id) { project in
                    projectInfos(for: project)
                }
            } else {
                ForEach(Array(user.projectsUsers.prefix(5))) { project in
                    projectInfos(for: project)
                }
            }
            chevronButton
        }
    }
    
    func projectInfos(for project: ProjectUser) -> some View{
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
    
    var chevronButton: some View {
        HStack {
            Spacer()
            
            Button("", systemImage: openAllProjects ? "chevron.up" : "chevron.down") {
                openAllProjects.toggle()
            }
            .foregroundColor(Colors.skillFiledColor.color)
        }
    }
    // ---------------------------------------------------
}

