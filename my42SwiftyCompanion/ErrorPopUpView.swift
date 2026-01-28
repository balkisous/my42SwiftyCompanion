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
    let buttonText: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack (alignment: .center, spacing: 30) {
            Text(title)
                .font(.bosaBold)
                .foregroundColor(Colors.foregroundColorError.color)
            Label(title, systemImage: "exclamationmark.triangle.fill")
            Text(subtitle)
                .font(.bosaSemiBold)
                .foregroundColor(Colors.foregroundColorError.color)
            Button(action: onDismiss) {
                Text(buttonText)
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}
