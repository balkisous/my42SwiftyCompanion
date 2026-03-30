//
//  HomeView.swift
//  my42SwiftyCompanion
//
//  Created by Balkis on 30/03/2026.
//

import SwiftUI

struct HomeView: View {
    
    @State var text: String = ""
//    var userManger : UserManager
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
                    
            topView
            
            TextField("Search 42 Users", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .font(.bodyMediumFont)
                .onChange(of: text) { _ in
                    print("text is \(text)")
                }
            
            Spacer()
        }
    }
    
    var topView : some View {
        VStack {
            Text("My42SwiftyCompanion")
                .fontWeight(.bold)
                .foregroundColor(Colors.titleColor.color)
                .font(.largeTitleFont)
                .padding(.vertical, 50)
            
            Image("42ParisLogo")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipped()
                .foregroundStyle(.tint)
                .cornerRadius(10)
            
            Text("Look for your 42Friends")
                .font(.bodyMediumFont)
                .foregroundColor(Colors.foregroundColorText.color)
        }
    }
}

#Preview {
    HomeView()
        .padding()
}

