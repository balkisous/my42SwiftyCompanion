//
//  HomeViewModel.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 30/03/2026.
//

import AuthenticationServices
import SwiftUI

class HomeViewModel : ObservableObject {
    
    @Published var users: [UsersResearch]
    var isAuthenticated = false // -> I think is not neccessary
    var isLoading = false // for what ??
    var errorMessage: String? = nil
    var isError = false
    
    private var keychainManager = KeychainManager.instance
    private let tokenKey = "authentificationToken"
    
    private let clientUID = Secrets.clientUID
    private let clientSecret = Secrets.clientSecret
    private let redirectURI = "my42SwiftyCompanion://oauth-callback"
    
    private let tokenURL = "https://api.intra.42.fr/oauth/token"
    private let apiURL = "https://api.intra.42.fr/v2/users" 
    
    private var accessToken: String?
    
    init() {
        self.users = [UsersResearch(id: 1, login: "tata"), UsersResearch(id: 2, login: "toto"), UsersResearch(id: 3, login: "titi")]
    }
    
    func fetchUsers(loginPrefix: String) async throws -> [UserProfile] {
        guard let token = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var components = URLComponents(string: "https://api.intra.42.fr/v2/users")!
        components.queryItems = [
            URLQueryItem(name: "search[login]", value: loginPrefix)
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            self.logout()
            throw URLError(.userAuthenticationRequired)
        }
        
        return try JSONDecoder().decode([UserProfile].self, from: data)
    }
    
    private func logout() {
        accessToken = nil
        users = []
        isAuthenticated = false
        do {
            try self.keychainManager.deleteToken(forKey: self.tokenKey)
        } catch {
            print(error)
        }
    }
    
    public func removeUser(){
        self.users.removeAll()
    }
}
