//
//  Colors.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 26/01/2026.
//

import SwiftUI

enum Colors {
    case titleColor
    case foregroundColorText
    case foregroundColorGray
    case backgroundbuttonColor
    case foregroundButtonColor
    case backgroundbuttonColorError
    case foregroundColorError
    case skillFiledColor
    case skillEmptyColor
    case percentageColor
    
    var color : Color {

        switch self {
        case .titleColor:
            return Color(red: 1.0, green: 1.0, blue: 1.0)
        
            // Color Teal/turquoise
        case .foregroundColorText:
            return Color(red: 0.85, green: 0.87, blue: 0.90)

        
            // Light gray for secondary text
        case .foregroundColorGray:
            return Color(red: 0.65, green: 0.68, blue: 0.72)
            
            // Vibrant teal
        case .backgroundbuttonColor:
            return Color(red: 0.35, green: 0.73, blue: 0.73)
        
            // White text on teal buttons
        case .foregroundButtonColor:
            return Color(red: 1.0, green: 1.0, blue: 1.0)
            
            // Soft red
        case .backgroundbuttonColorError:
            return Color(red: 0.9, green: 0.35, blue: 0.35)
            
            // White on red
        case .foregroundColorError:
            return Color(red: 1.0, green: 1.0, blue: 1.0)
            
            // Lighter teal variant
        case .skillFiledColor:
            return Color(red: 0.45, green: 0.78, blue: 0.78)
            
            // Dark gray matching sidebar
        case .skillEmptyColor:
            return  Color(red: 0.18, green: 0.20, blue: 0.24)
            
            // Accent teal
        case .percentageColor:
            return Color(red: 0.35, green: 0.73, blue: 0.73)
        }
    }
    
    static var gradientColors: [Color] {
        [
            Color(red: 0.15, green: 0.17, blue: 0.21),
            Color(red: 0.11, green: 0.12, blue: 0.15)
        ]
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
