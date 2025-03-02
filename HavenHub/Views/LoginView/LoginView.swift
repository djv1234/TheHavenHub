//
//  LoginPage.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/28/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var viewManager: ViewManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            
            HStack{
                Button {
                    authViewModel.signIn(email: email, password: password) { result in
                        switch result {
                        case .success:
                            errorMessage = nil
                            withAnimation(){
                                viewManager.checkUserStatus()
                            }
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 50)
                        Text("Login")
                            .foregroundStyle(.white)
                    }
                }
                
                Button {
                    authViewModel.signInWithGoogle { result in
                        switch result {
                        case .success:
                            errorMessage = nil
                            withAnimation(){
                                viewManager.navigateToMain()
                            }
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 50)
                            .foregroundStyle(.ultraThinMaterial)
                        HStack{
                            Image("google")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Login")
                                .foregroundStyle(.mainOpp)
                        }
                    }
                }
            }
            
            
            Button {
                withAnimation(){
                    viewManager.navigateToSignUp()
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(width: 200, height: 50)
                    Text("Sign Up")
                }
            }
            
            Button {
                withAnimation(){
                    viewManager.navigateToSignUpShelter()
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(width: 200, height: 50)
                    Text("Shelter Sign Up")
                }
            }
        }
        .padding()
        .navigationTitle("Firebase Auth")
    }
}

