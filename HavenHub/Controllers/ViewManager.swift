//
//  ViewManager.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import FirebaseAuth
import Foundation
import FirebaseDatabase
import GoogleSignIn
import FirebaseCore

class ViewManager: ObservableObject {
    @Published var currentView: ViewType
    
    enum ViewType {
        case main
        case health
        case anxiety
        case login
        case signup
        case signupshelter
        case text
        case shelter
    }
    
    init() {
        if Auth.auth().currentUser != nil {
            fetchUserRole { role in
                DispatchQueue.main.async { // Ensure UI updates happen on the main thread
                    if role == "shelter" {
                        self.currentView = .shelter
                    } else {
                        self.currentView = .main
                    }
                }
            }
        } else {
            self.currentView = .login
        }
    }
    
    func fetchUserRole(completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference()
        
        if let userId = Auth.auth().currentUser?.uid {
            ref.child("users").child(userId).child("role").observeSingleEvent(of: .value) { snapshot in
                completion(snapshot.value as? String) // Assuming "role" is stored as a String (e.g., "shelter" or "user")
            }
        } else {
            completion(nil)
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
    
    func navigateToSignUpShelter() {
        currentView = .signupshelter
    }
    
    func navigateText() {
        currentView = .text
    }
}

