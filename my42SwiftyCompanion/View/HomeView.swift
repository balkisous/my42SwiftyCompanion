//
//  HomeView.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 30/03/2026.
//

import SwiftUI

struct HomeView: View {
    
    @State var text: String = ""
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
            
            topView
            
            textFieldView
            
            Spacer()
        }
    }

    // MARK: Views

    var topView : some View {
        VStack {
            Text("My42SwiftyCompanion")
                .fontWeight(.bold)
                .foregroundColor(Colors.titleColor.color)
                .font(.largeTitleFont)
                .padding(.vertical, 50)
            
            Image("42ParisLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipped()
                .foregroundStyle(.tint)
                .cornerRadius(10)
            
            Text("Look for your 42Friends")
                .font(.bodyMediumFont)
                .foregroundColor(Colors.foregroundColorText.color)
        }
    }
    
    var textFieldView : some View {
        TextField("Search 42 Users", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.bodyMediumFont)
            .onChange(of: text, { _ , _ in
                if text.isEmpty {
//                        print("view model user before is \(viewModel.users)")
                    viewModel.removeAllUser()
//                        print("view model user after is \(viewModel.users)")
                } else {
                    Task {
                        try await viewModel.fetchUsers(loginPrefix: text)
                    }
                }
            })
            .overlay(alignment: .topLeading) {
                if !viewModel.users.isEmpty && !text.isEmpty {
                    GeometryReader { geo in
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.users) { user in
                                    Button {
                                        // navigate to userView
                                        print("user is \(user)")
                                        viewModel.removeAllUser()
                                        Task {
                                            do {
                                                if let user = try await viewModel.fetchUserProfile(id: user.id) {
                                                    print("user fetch is \(user)")
                                                }
                                            }
                                            catch {
                                                print("Error from Fetching user profile: \(error)")
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(user.login)
                                                .font(.bodyMediumFont)
                                                .foregroundStyle(Colors.backgroundbuttonColor.color)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.bodyMediumFont)
                                                .foregroundStyle(Colors.backgroundbuttonColor.color)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .contentShape(Rectangle())
                                    }
                                    if user.id != viewModel.users.last?.id {
                                        Divider()
                                            .padding(.leading, 10)
                                    }
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.background)
                                .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
                        )
                        .frame(width: geo.size.width, height: isFixedHeight ? (geo.size.height * CGFloat(viewModel.users.count + 1)) : 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .animation(.easeInOut(duration: 0.2), value: viewModel.users.isEmpty)
                        .offset(y: geo.size.height)
                    }
                }
            }
            .padding()
    }
    
    // MARK: Helper
    
    var isFixedHeight : Bool {
        if viewModel.users.count > 4 {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    HomeView()
        .padding()
}

