//
//  Colors.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 26/01/2026.
//

import SwiftUI

enum Colors {
    case backgroundColor
    case titleColor
    case filedColor
    case foregroundColorGray
    case backgroundbuttonColor
    case foregroundButtonColor
    case backgroundbuttonColorError
    case foregroundColorError
    
    var color : Color {
        switch self {
        case .backgroundColor:
            return Color(hex: 0x0FEFAE0, opacity: 1)
        case .titleColor:
            return Color(hex: 0x0D4A373, opacity: 1)
        case .filedColor:
            return Color(hex: 0x0FAEDCD, opacity: 1)
        case .foregroundColorGray:
            return Color(hex: 0x0CCBAA8, opacity: 1)
        case .backgroundbuttonColor:
            return Color(hex: 0x0D2BA9E, opacity: 1)
        case .foregroundButtonColor:
            return Color(hex: 0x0FAEDCD, opacity: 1)
        case .backgroundbuttonColorError:
            return Color(hex: 0x0C1121F, opacity: 1)
        case .foregroundColorError:
            return Color(hex: 0x0780000, opacity: 1)
        }
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
