//
//  Authentification.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 28/01/2026.
//

import Foundation
import AuthenticationServices
import SwiftUI

class Auth42Manager: NSObject, ObservableObject {
    @Published var user: UserProfile?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isError = false
    
    private var keychainManager = KeychainManager.instance
    private let tokenKey = "authentificationToken"
    
    private let clientUID = Secrets.clientUID
    private let clientSecret = Secrets.clientSecret
    private let redirectURI = "my42SwiftyCompanion://oauth-callback"
    
    private let authURL = "https://api.intra.42.fr/oauth/authorize"
    private let tokenURL = "https://api.intra.42.fr/oauth/token"
    private let apiURL = "https://api.intra.42.fr/v2"
    
    private var accessToken: String?
    
    override init() {
        super.init()
        checkExistingToken()
    }
    
    // Authentification
    func authenticate() {
        
        if isAuthenticated {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var components = URLComponents(string: authURL)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientUID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "public")
        ]
        
        guard let url = components.url else { return }
        
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: redirectURI.components(separatedBy: ":").first
        ) { [weak self] callbackURL, error in
            guard let self = self else { return }
            
            if let error = error {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.isError = true
                return
            }
            
            guard let callbackURL = callbackURL,
                  let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "code" })?.value else {
                self.isLoading = false
                self.errorMessage = "Authorised code not received"
                self.isError = true
                return
            }
            
            self.exchangeCodeForToken(code: code)
        }
        
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = false
        session.start()
    }
    
    
    private func exchangeCodeForToken(code: String) {
        var request = URLRequest(url: URL(string: tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let params = [
            "grant_type": "authorization_code",
            "client_id": clientUID,
            "client_secret": clientSecret,
            "code": code,
            "redirect_uri": redirectURI
        ]
        
        request.httpBody = params.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let token = json["access_token"] as? String else {
                    self.isLoading = false
                    self.errorMessage = "Token not received"
                    self.isError = true
                    return
                }
                
                self.accessToken = token
                if !self.saveToken(for: token) {
                    return
                }
                self.fetchUserData()
            }
        }.resume()
        
        
    }
    
    // Save token on the Keychain
    private func saveToken(for token: String) -> Bool{
        do {
            try self.keychainManager.saveToken(token, forKey: self.tokenKey)
            print("Successfully saved token")
        } catch {
            self.isLoading = false
            self.errorMessage = "Error from Keychain Manager: \(error)"
            self.isError = true
            print(error)
            return false
        }
        return true
    }
    
    private func fetchUserData() {
        guard let token = accessToken else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Token not found"
                self.isError = true
            }
            return
        }
        
        var request = URLRequest(url: URL(string: "\(apiURL)/me")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        self.errorMessage = "Token expired, please log in again"
                        self.isError = true
                        self.logout()
                        return
                    }
                }
                guard let data = data else {
                    self.errorMessage = "data not received"
                    self.isError = true
                    return
                }
                
                do {
                    let user = try JSONDecoder().decode(UserProfile.self, from: data)
                    self.user = user
                    self.isAuthenticated = true
                } catch {
                    self.errorMessage = "Error from decoding: \(error)"
                    self.isError = true
                    print(error)
                }
            }
        }.resume()
    }
    
    func logout() {
        accessToken = nil
        user = nil
        isAuthenticated = false
        do {
            try self.keychainManager.deleteToken(forKey: self.tokenKey)
        } catch {
            print(error)
        }
    }
    
    func checkExistingToken() {
        if let token = keychainManager.getToken(forKey: tokenKey) {
            print("Token trouvé dans le Keychain")
            accessToken = token
            isLoading = true
            fetchUserData()
        }
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension Auth42Manager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
