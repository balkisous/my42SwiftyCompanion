//
//  UserProfile.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 28/01/2026.
//r

import Foundation

// MARK: - Models
struct UserProfile: Codable {
    
    let login: String
    let email: String
    let phone: String?
    let location: String?
    let wallet: Int
    let correctionPoint: Int
    let image: UserImage
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectUser]
    
    enum CodingKeys: String, CodingKey {
        case login, email, phone, location, wallet, image
        case correctionPoint = "correction_point"
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
    }
    
    // Helpers
    var level: Double { cursusUsers.first?.level ?? 0.0 }
    var skills: [Skill] { cursusUsers.first?.skills ?? [] }
    var profileImage: String { image.versions.medium }
}

struct UserImage: Codable {
    let versions: ImageVersions
}

struct ImageVersions: Codable {
    let medium: String
}

struct CursusUser: Codable {
    let level: Double
    let skills: [Skill]
}

struct Skill: Codable {
    let name: String
    let level: Double
    
    var percentage: Double { (level / 20.0) * 100.0 }
}

struct ProjectUser: Codable {
    let finalMark: Int?
    let validated: Bool?
    let status: String
    let project: Project
    
    enum CodingKeys: String, CodingKey {
        case validated, status, project
        case finalMark = "final_mark"
    }
    
    var isPassed: Bool { validated == true }
    var isFailed: Bool { validated == false }
}

struct Project: Codable {
    let name: String
}

// MARK: - Decoder Extension
extension UserProfile {
    static func decode(from data: Data) throws -> UserProfile {
        let decoder = JSONDecoder()
        return try decoder.decode(UserProfile.self, from: data)
    }
    
    static func decode(from json: String) throws -> UserProfile {
        guard let data = json.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Cannot convert JSON string to Data"
                )
            )
        }
        return try decode(from: data)
    }
}

//// MARK: - Usage Examples
//extension UserProfile {
//    // Decode from Data
//    static func fromData(_ data: Data) -> Result<UserProfile, Error> {
//        do {
//            let user = try decode(from: data)
//            return .success(user)
//        } catch {
//            return .failure(error)
//        }
//    }
//    
//    // Decode from JSON String
//    static func fromJSON(_ json: String) -> Result<UserProfile, Error> {
//        do {
//            let user = try decode(from: json)
//            return .success(user)
//        } catch {
//            return .failure(error)
//        }
//    }
//}
