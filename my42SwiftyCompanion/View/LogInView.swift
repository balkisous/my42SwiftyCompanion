//
//  ContentView.swift
//  my42SwiftyCompanion
//
//  Created by balkis wang on 09/01/2026.
//

import SwiftUI

struct LogInView: View {
    
    @State private var login: String = ""
    @State private var password: String = ""
    @State private var isSecure = false
    
    var body: some View {
        VStack (spacing: 30) {
           titleView
            
            Image("42ParisLogo")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .cornerRadius(10)
                       
            logInTexFields
            
            logInButton
        }
        .padding()
    }
        
    var titleView : some View {
        VStack (alignment: .center, spacing: 0) {
            Text("My42SwiftyCompanion")
                .fontWeight(.bold)
                .foregroundColor(Colors.titleColor.color)
                .fontWidth(.standard)
            Text("Your custom 42Profile app")
                .font(.bosaBold)
                .foregroundColor(Colors.titleColor.color)
        }
    }
    
    
    @ViewBuilder
    private var logInTexFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Login", text: $login)
                .background(Color(.blue))
                .foregroundColor(Colors.foregroundColorGray.color)
                .textFieldStyle(.roundedBorder)
            
            HStack {
                        Group {
                            if isSecure {
                                VStack {
                                    SecureField("Password", text: $password)
                                        .background(Colors.filedColor.color)
                                    
                                }
                            } else {
                                TextField("Password", text: $password)
                                    .background(Colors.filedColor.color)

                            }
                        }
                        .background(Colors.filedColor.color)

                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                        }
                    }
                    .textFieldStyle(.roundedBorder)
        }
    }
    
    var logInButton: some View {
        Button("Log In") {
            print("Log In with \(login) and \(password) make the call")
            
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 10)
        .background(Colors.backgroundbuttonColor.color)
        .foregroundColor(Colors.foregroundButtonColor.color)
        .border(Colors.foregroundButtonColor.color, width: 1)
        .cornerRadius(10)

    }
}

#Preview {
    LogInView()
}
