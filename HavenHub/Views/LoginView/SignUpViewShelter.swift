//
//  SingUpView.swift
//  MiniMate
//
//  Created by Garrett Butchko on 2/6/25.
//


import SwiftUI

struct SignUpViewShelter: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var locType = ""
    @State private var errorMessage: String?
    
    private var shelterData: [String: Any] {
        [
            "name": name,
            "address": address,
            "phoneNumber": phone,
            "email": email,
            "userType": "shelter",
            "verified": false
        ]
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Phone Number", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.phonePad)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button("Sign Up") {
                
                authViewModel.createUser(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        errorMessage = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Slight delay to ensure user is set
                            saveShelterData()
                        }
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        
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
    
    private func saveShelterData() {
        authViewModel.saveUserData(key: "Shelter Data", data: shelterData) { success in
            if success {
                withAnimation {
                    viewManager.navigateText()
                }
            } else {
                errorMessage = "Failed to save user data."
            }
        }
    }
}
