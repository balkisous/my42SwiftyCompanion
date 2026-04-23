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
    
    @State private var selectedUser: UserProfile? = nil
    
    private let rowHeight: CGFloat = 44
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
            
            topView
            
            textFieldView
            
            Spacer()
        }
        .sheet(item: $selectedUser, onDismiss: {
            text = ""
            viewModel.removeAllUser()
        }) { user in
            UserView(user: user)
        }
        
        .alert("Error", isPresented: $viewModel.isError) {
            Button("Dismiss", role: .cancel) { }
                .tint(.red)
        } message: {
            Text(viewModel.errorMessage ?? "Unknown Error")
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
            .onChange(of: text, { _ , newValue in
                if newValue.isEmpty {
                    viewModel.removeAllUser()
                } else {
                    viewModel.search(login: newValue)
                }
            })
            .overlay(alignment: .topLeading) {
                
                Group {
                    if !text.isEmpty && text.count <= 2 {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.background)
                                .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
                        )
                    } else if !viewModel.users.isEmpty && !text.isEmpty {
                        let maxVisible = 5
                        let height = CGFloat(min(viewModel.users.count, maxVisible)) * rowHeight
                        
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.users) { user in
                                    userRow(user)
                                    
                                    if user.id != viewModel.users.last?.id {
                                        Divider().padding(.leading, 16)
                                    }
                                }
                            }
                        }
                        .frame(height: height)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.background)
                                .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .animation(.easeInOut(duration: 0.2), value: viewModel.users.count)
                    }
                }
                .offset(y: rowHeight - 9)
            }
            .padding()
    }
    
    func userRow(_ user: UsersResearch) -> some View {
        Button {
            viewModel.removeAllUser()
            Task {
                do {
                    if let profile = try await viewModel.fetchUserProfile(id: user.id) {
                        selectedUser = profile
                    }
                } catch {
                    print("Error fetching profile: \(error)")
                    await MainActor.run {
                        viewModel.isError = true
                        viewModel.errorMessage = error.localizedDescription
                    }
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
            .frame(height: rowHeight)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
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

