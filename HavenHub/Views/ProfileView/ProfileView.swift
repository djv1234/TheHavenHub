//
//  Untitled.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewManager: ViewManager
    @StateObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    if authViewModel.user != nil {
                        if authViewModel.user != nil {
                            Button("Logout") {
                                authViewModel.logout()
                            }
                            .buttonStyle(.bordered)
                        }
                    } else {
                        Button(action: {
                            withAnimation{
                                viewManager.navigateToLogin()
                            }
                        }) {
                            ZStack {
                                Capsule()
                                    .frame(width: 200, height: 50)
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundColor(.white)
                                    Text("Login")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                .padding()
                .padding(.top, 40)
            }
            
            HStack{
                Button(action: {
                    withAnimation{
                        viewManager.navigateToMain()
                    }
                }) {
                    ZStack {
                        Circle()
                        VStack {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: 30, height: 30)
                .padding(.leading)
                
                Spacer()
                
                Text("Profile")
                    .frame(width: 250, height: 40)
                    .font(.title)
                    .foregroundColor(.primary)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .fontWeight(.bold)
                
                Spacer()
                Spacer()
            }
        }
    }
}
