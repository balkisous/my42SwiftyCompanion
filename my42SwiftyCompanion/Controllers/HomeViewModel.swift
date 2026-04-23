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
    private var cache: [String: [UsersResearch]] = [:]
    
    private var keychainManager = KeychainManager.instance // -> A voir si on le garde ou pas
    private let tokenKey = "authentificationToken" // -> A voir si on le garde ou pas
    
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
    
    
    func search(login: String) {
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
    
    private var currentDataTask: URLSessionDataTask?


    
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
    }
    
    func fetchUsers(loginPrefix: String) async throws {
           
        if let cached = cache[loginPrefix] {
            await MainActor.run { self.users = cached }
            return
        }
        
        guard let token = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
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
    
    func fetchUserProfile(id: Int) async throws -> UserProfile? {
        guard let token = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
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
    
    public func removeAllUser(){
        self.users.removeAll()
    }
}
