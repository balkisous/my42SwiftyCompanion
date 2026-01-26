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
        VStack (spacing: 20) {
            Image("42ParisLogo")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Log in to your 42 account")
                .fontWeight(.heavy)
            TextField("Login", text: $login)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(Color)
           secureField
            Button("Log In") {
                print("Log In with \(login) and \(password)")
            }
            .buttonStyle(.borderedProminent)
            
           
                
        }
        .padding()
    }
    
    @ViewBuilder
    private var secureField: some View {
        HStack {
                    Group {
                        if isSecure {
                            SecureField("Password", text: $password)
                        } else {
                            TextField("Password", text: $password)
                        }
                    }

                    Button {
                        isSecure.toggle()
                    } label: {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                    }
                }
                .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    LogInView()
}
