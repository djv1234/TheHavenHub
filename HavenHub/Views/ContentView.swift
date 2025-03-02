//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewManager = ViewManager()
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            switch viewManager.currentView {
            case .main:
                MainView(viewManager: viewManager, authViewModel: authViewModel)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
            case .health:
                HealthView(viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .anxiety:
                AnxietyView(viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .login:
                LoginView(authViewModel: authViewModel, viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .signup:
                SignUpView(authViewModel: authViewModel, viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .signupshelter:
                SignUpViewShelter(authViewModel: authViewModel, viewManager: viewManager)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .text:
                Text("Please wait until you are verified, thank you!")
                Button("Logout") {
                    withAnimation {
                        viewManager.navigateToLogin()
                    }
                    authViewModel.logout()
                }
            case .shelter:
                ShelterView(viewManager: viewManager, authViewModel: authViewModel)
            }
        }
    }
}
