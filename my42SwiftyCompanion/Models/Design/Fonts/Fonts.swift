//
//  Fonts.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 27/01/2026.
//

import SwiftUI

extension Font {
        static var titleFont: Font {
            .system(size: 28, weight: .bold, design: .serif)
        }
        
        static var largeTitleFont: Font {
            .system(size: 30, weight: .bold, design: .serif)
        }
        
        static var bodyFont: Font {
            .system(size: 18, weight: .regular, design: .serif)
        }
        
        static var bodyMediumFont: Font {
            .system(size: 20, weight: .semibold, design: .rounded)
        }
    
        static var subheadlineFont: Font {
            .system(size: 22, weight: .semibold, design: .serif)
        }
        
        static var captionFont: Font {
            .system(size: 14, weight: .regular, design: .serif)
        }
        
        static var buttonFont: Font {
            .system(size: 17, weight: .semibold, design: .default)
        }
}
