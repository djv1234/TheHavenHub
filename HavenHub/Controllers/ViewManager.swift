//
//  ViewManager.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import FirebaseAuth

class ViewManager: ObservableObject {
    @Published var currentView: ViewType
    
    enum ViewType {
        case main
        case health
        case anxiety
        case login
        case signup
    }
    
    init() {
        // Check if a user is logged in
        if Auth.auth().currentUser != nil {
            self.currentView = .main
        } else {
            self.currentView = .login
        }
   
    }
    
    func navigateToMain() {
        currentView = .main
    }
    
    func navigateToHealth() {
        currentView = .health
    }
   
    func navigateToAnxiety(){
        currentView = .anxiety
    }

    func navigateToLogin() {
        currentView = .login
    }
    
    func navigateToSignUp() {
        currentView = .signup
    }
}

