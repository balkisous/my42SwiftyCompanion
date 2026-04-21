//
//  TokenResponse.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 21/04/2026.
//

struct TokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let createdAt: Int
}
