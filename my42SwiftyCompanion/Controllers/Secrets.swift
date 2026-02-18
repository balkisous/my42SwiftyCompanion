//
//  Secrets.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 17/02/2026.
//

import Foundation


enum Secrets {
    
    static func value(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String,
              !value.isEmpty else {
            fatalError("⚠️ Key '\(key)' missing in Secrets.xcconfig")
        }
        return value
    }
    
    static var clientUID: String { value(for: "CLIENT_UID") }
    static var clientSecret: String { value(for: "CLIENT_SECRET") }
}
