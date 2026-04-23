//
//  UserProfile.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 28/01/2026.
//

import Foundation

// MARK: - Models
struct UserProfile: Decodable, Identifiable {
    
    let id: Int
    let login: String
    let email: String
    let location: String?
    let wallet: Int?
    let correctionPoint: Int?
    let image: UserImage?
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectUser]
    let alumni: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, login, email, location, wallet, image
        case correctionPoint = "correction_point"
        case cursusUsers     = "cursus_users"
        case projectsUsers   = "projects_users"
        case alumni          = "alumni?"
    }
    
    // Helpers
    var level: Double  { cursusUsers.first?.level ?? 0.0 }
    var skills: [Skill] { cursusUsers.first?.skills ?? [] }
    var profileImage: String { image?.versions?.medium ?? "" }
    
    var userIsInCursus: CursusUser {
        if self.cursusUsers.count > 1 {
            return self.cursusUsers[1]
        } else {
            return self.cursusUsers[0]
        }
    }
}

struct UserImage: Decodable {
    let link: String?
    let versions: ImageVersions?
}

struct ImageVersions: Decodable {
    let large: String?
    let medium: String?
    let small: String?
    let micro: String?
}

struct CursusUser: Decodable {
    let level: Double
    let skills: [Skill]
    let cursus: Cursus?
}

struct Cursus: Decodable {
    let name: String
}

struct Skill: Decodable {
    let name: String
    let level: Double
    var percentage: Double { min((level / 20.0) * 100.0, 100.0) }
}

struct ProjectUser: Decodable, Identifiable {
    let id: Int
    let finalMark: Int?
    let validated: Bool?
    let status: String
    let project: Project
    let cursusIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case status, project, id
        case validated = "validated?"
        case finalMark = "final_mark"
        case cursusIds  = "cursus_ids"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.finalMark = try container.decodeIfPresent(Int.self, forKey: .finalMark)
        self.validated = try container.decodeIfPresent(Bool.self, forKey: .validated)
        self.status    = try container.decode(String.self, forKey: .status)
        self.project   = try container.decode(Project.self, forKey: .project)
        self.id        = try container.decode(Int.self, forKey: .id)
        self.cursusIds = try container.decode([Int].self, forKey: .cursusIds)
    }
}

struct Project: Decodable {
    let name: String
}


// MARK: - Decoder Extension
//extension UserProfile {
//    static func decode(from data: Data) throws -> UserProfile {
//        let decoder = JSONDecoder()
//        return try decoder.decode(UserProfile.self, from: data)
//    }
//    
//    static func decode(from json: String) throws -> UserProfile {
//        guard let data = json.data(using: .utf8) else {
//            throw DecodingError.dataCorrupted(
//                DecodingError.Context(
//                    codingPath: [],
//                    debugDescription: "Cannot convert JSON string to Data"
//                )
//            )
//        }
//        return try decode(from: data)
//    }
//}

// MARK: - Utils
extension UserProfile {
    func projectStatus(for project: ProjectUser) -> String {
        if project.validated == false {
            return "❌"
        }
        switch project.status {
        case "finished":
            return "✅"
        case "waiting_for_correction":
            return "⏸️"
        case "in_progress":
            return "⏳"
        case "searching_a_group":
            return "🔍"
        default:
            return "📊"
        }
    }
}
