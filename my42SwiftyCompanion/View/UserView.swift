//
//  UserView.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 29/01/2026.
//

import SwiftUI

struct UserView: View {

    let user: UserProfile
    @State var openAllProjects: Bool = false
    @State var openAllSkills: Bool = false
    @Environment(\.dismiss) private var dismiss
    
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
        }
        .background(
            LinearGradient(
                colors: Colors.gradientColors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

extension UserView {
    
    // ---------------------- Header ----------------------

    var headerProfile: some View {
        HStack {
            AsyncImage(url: URL(string: user.profileImage)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .clipShape(Circle())
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.gray)
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .clipShape(Circle())
                }
            }
            
            
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.titleFont)
                    .bold()
                    .foregroundColor(Colors.titleColor.color)
                Text(user.email)
                    .font(.bodyMediumFont)
                    .foregroundColor(Colors.foregroundColorText.color)
                let user = user.userIsInCursus
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
            if let wallet = user.wallet {
                InfoRow(icon: "💰", text: "Wallet: \(wallet) ₳")
            }
            if let points = user.correctionPoint {
                InfoRow(icon: "⭐", text: "Evaluations points: \(points)")
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
    
    // ---------------------- Skills ----------------------

    var userSkills : some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skills")
                .foregroundColor(Colors.titleColor.color)
                .font(.subheadlineFont)
            
            let user = user.userIsInCursus
            
            ForEach(user.skills.prefix(5), id: \.name) { skill in
                skillRow(for: skill)
            }
            .transition(.opacity.combined(with: .move(edge: .top)))

            
            if openAllSkills {
                ForEach(user.skills.dropFirst(5), id: \.name) { skill in
                    skillRow(for: skill)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            chevronSkillsButton
        }
        .animation(.interactiveSpring(duration: 0.3), value: openAllSkills)
    }
    
    func skillRow(for skill: Skill) -> some View  {
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

    // ---------------------- Projects ----------------------
    var userProjects : some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Projects")
                .foregroundColor(Colors.foregroundColorText.color)
                .font(.subheadlineFont)
            
            ForEach(Array(user.projectsUsers.prefix(5))) { project in
                projectInfos(for: project)
            }
            
            if openAllProjects {
                ForEach(user.projectsUsers, id: \.id) { project in
                    projectInfos(for: project)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
                
            chevronProjectsButton
        }
        .animation(.interactiveSpring(duration: 0.3), value: openAllProjects)
    }
    
    func projectInfos(for project: ProjectUser) -> some View {
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
    
    var chevronProjectsButton: some View {
        HStack {
            Spacer()
            
            Button("", systemImage: openAllProjects ? "chevron.up" : "chevron.down") {
                openAllProjects.toggle()
            }
            .foregroundColor(Colors.skillFiledColor.color)
        }
    }
    
    var chevronSkillsButton: some View {
        HStack {
            Spacer()
            
            Button("", systemImage: openAllSkills ? "chevron.up" : "chevron.down") {
                openAllSkills.toggle()
            }
            .foregroundColor(Colors.skillFiledColor.color)
        }
    }
    // ---------------------------------------------------
}

#Preview {
    var user = UserProfile(id: 75980, login: "bben-yaa", email: "bben-yaa@student.42.fr", location: nil, wallet: 650, correctionPoint: 2, image: UserImage(link: "https://cdn.intra.42.fr/users/7f2711f31bea8caf489d89a2b1705a5d/bben-yaa.jpg", versions: nil), cursusUsers: [CursusUser(level: 6.46, skills: [Skill(name: "Unix", level: 7.13), Skill(name: "Unix", level: 7.13), Skill(name: "Unix", level: 7.13), Skill(name: "Unix", level: 7.13), Skill(name: "Unix", level: 7.13), Skill(name: "Unix", level: 7.13), Skill(name: "Unix", level: 7.13)], cursus: Cursus(name: ""))], projectsUsers: [])
    UserView(user: user)
}

