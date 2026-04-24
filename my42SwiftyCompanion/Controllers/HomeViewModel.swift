//
//  HomeViewModel.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 30/03/2026.
//

import AuthenticationServices
import SwiftUI

class HomeViewModel : ObservableObject {
    
    @Published var users: [UsersResearch] = []
    @Published var isError = false
    @Published var errorMessage: String? = nil
    @Published var noResults = false
    private var tokenExpiresAt: Date?
    private var cache: [String: [UsersResearch]] = [:]
        
    private let clientUID = Secrets.clientUID
    private let clientSecret = Secrets.clientSecret
    
    private let tokenURL = "https://api.intra.42.fr/oauth/token"
    private let apiUserURL = "https://api.intra.42.fr/v2/users"
    
    private var accessToken: String?
    private var searchTask: Task<Void, Never>?
    
    init() {
        Task {
            do {
                try await self.fetchAccessToken()
//                 throw URLError(.notConnectedToInternet)
//                 -> to test alert error feature
            }
            catch {
                print("Error to fetch access token: \(error)")
                await MainActor.run {
                    self.isError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
        
    }
    
    deinit {
        self.users = []
    }
    
    // ---------------------- Token ----------------------

    private func validToken() async throws -> String {
        if let token = accessToken,
           let expiresAt = tokenExpiresAt,
           Date() < expiresAt.addingTimeInterval(-60) {
            print("token still valid")
            return token
        }
        print("token expired → fetching new one...")
        try await fetchAccessToken()
        return accessToken!
    }

    private func executeWithTokenRefresh<T>(_ request: (String) async throws -> T) async throws -> T {
        let token = try await validToken()
        print("using token: \(token.prefix(10))...")
        do {
            return try await request(token)
        } catch let error as URLError where error.code == .userAuthenticationRequired {
            // 401 reçu → on force le refresh et on retry une fois
            print("401 received → refreshing token...")
            try await fetchAccessToken()
            print("token refreshed: \(accessToken!.prefix(10))...")
            return try await request(accessToken!)
        }
    }
    
    private func fetchAccessToken() async throws {
        
        let url = URL(string: tokenURL)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = "grant_type=client_credentials&client_id=\(clientUID)&client_secret=\(clientSecret)"
        
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        
        self.accessToken = tokenResponse.accessToken
        self.tokenExpiresAt = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
        
//        self.tokenExpiresAt = Date().addingTimeInterval(-1)
//        -> test for expire token
        
    }
        
    // ----------------------------------------------------------------

    
    // ---------------------- Fetch Search Users ----------------------
    
    func search(login: String) {
//        self.isError = true
//        self.errorMessage = "Test Error message"
//        return
//         -> to test alert error feature

        searchTask?.cancel()
        
        guard login.count >= 2 else {
            users = []
            return
        }
        
        searchTask = Task {
            do {
                   try await Task.sleep(for: .seconds(0.3))
                   try await fetchUsers(loginPrefix: login)
               } catch is CancellationError {
                   return
               } catch let error as URLError where error.code == .cancelled {
                   return
               } catch {
                   await MainActor.run {
                       self.isError = true
                       self.errorMessage = error.localizedDescription
                   }
               }
        }
    }

    
    func fetchUsers(loginPrefix: String) async throws {
           
        if let cached = cache[loginPrefix] {
            await MainActor.run { self.users = cached }
            return
        }
        
        try await executeWithTokenRefresh { token in
            
            var components = URLComponents(string: apiUserURL)!
            components.queryItems = [
                URLQueryItem(name: "search[login]", value: loginPrefix),
                URLQueryItem(name: "page[size]", value: "10")
            ]
            
            var request = URLRequest(url: components.url!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 10
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let decoder = try JSONDecoder().decode([UsersResearch].self, from: data)
                    await MainActor.run {
                        self.cache[loginPrefix] = decoder
                        self.users = decoder
                        self.noResults = decoder.isEmpty
                    }
                case 401:
                    throw URLError(.userAuthenticationRequired)
                case 429:
                    throw URLError(.resourceUnavailable)
                default :
                    throw URLError(.badServerResponse)
                }
            }
        }
    }
    
    // ----------------------------------------------------------------

    
    // ---------------------- Fetch User Profile ----------------------
    
    func fetchUserProfile(id: Int) async throws -> UserProfile? {
        try await executeWithTokenRefresh { token in
            
            let url = URL(string: "\(apiUserURL)/\(id)")!
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                    return userProfile
                case 401:
                    throw URLError(.userAuthenticationRequired)
                case 429:
                    throw URLError(.resourceUnavailable)
                default :
                    throw URLError(.badServerResponse)
                }
            }
            return nil
        }
    }
    
    public func removeAllUser(){
        self.users.removeAll()
    }
}
