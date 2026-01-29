//
//  ErrorPopUpView.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 27/01/2026.
//

import SwiftUI

struct ErrorPopUpView: View {
    
    let title: String
    let subtitle: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack (alignment: .center, spacing: 30) {
            Label(title, systemImage: "exclamationmark.triangle.fill")
                .font(.bosaBold)
                .foregroundColor(Colors.foregroundColorError.color)
            Text(subtitle)
                .font(.bosaSemiBold)
                .foregroundColor(Colors.foregroundColorError.color)
            Button("Dismiss") {
                onDismiss()
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 10)
            .background(Colors.backgroundbuttonColorError.color)
            .foregroundColor(Colors.foregroundButtonColor.color)
            .border(Colors.foregroundButtonColor.color, width: 1)
            .cornerRadius(10)
        }
        .padding()
    }
}
