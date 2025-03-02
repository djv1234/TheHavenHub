//
//  SingUpView.swift
//  MiniMate
//
//  Created by Garrett Butchko on 2/6/25.
//


import SwiftUI

struct SignUpView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    
    @State private var password = ""
    
    @State private var errorMessage: String?
    
    @State private var user = UserModel(name: "", email: "", password: "")
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Name", text: $user.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Email", text: $user.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Sign Up") {
                
                authViewModel.createUser(email: user.email, password: password) { result in
                    switch result {
                    case .success(_):
                        errorMessage = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Slight delay to ensure user is set
                            authViewModel.saveUserData(user: user) { success in
                                if success {
                                    withAnimation {
                                        viewManager.navigateToMain()
                                    }
                                } else {
                                    errorMessage = "Failed to save user data."
                                }
                            }
                        }
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            // Close button
            Button(action: {
                // Close the emergency view with animation
                withAnimation {
                    viewManager.navigateToLogin()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial) // Semi-transparent circular background
                        .frame(width: 70, height: 70) // Size of the button
                    
                    Text("X")
                        .font(.system(size: 25)) // Font size for the close symbol
                        .foregroundStyle(Color.primary) // Color for the text
                }
            }
            .padding()
        }
        .padding()
    }
}
