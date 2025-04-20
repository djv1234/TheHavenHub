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
import CoreLocation
import MapKit

class ViewManager: ObservableObject {
    @Published var currentView: ViewType = .login // Default to login
    
    enum ViewType {
        case main
        case health
        case healthModel(HealthModel)
        case healthDetail(MKMapItem, HealthModel)
        case healthResources(HealthModel)
        case login
        case signup
        case signupshelter
        case text
        case shelter
        case profile
    }
    
    init() {
        checkUserStatus()
    }
    
    func checkUserStatus() {
        guard Auth.auth().currentUser != nil else {
            DispatchQueue.main.async {
                self.currentView = .login
            }
            return
        }
        
        fetchUserRole { role in
            DispatchQueue.main.async {
                if role == "shelter"{
                    self.fetchIsVerified { verified in
                        if verified! {
                            self.currentView = .shelter
                        } else {
                            self.currentView = .text
                        }
                    }
                } else {
                    self.currentView = .main
                }
            }
        }
    }
    
    private func fetchUserRole(completion: @escaping (String?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let ref = Database.database().reference()
        ref.child(userId).child("userType").observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.value as? String) // Role is assumed to be stored as a String
        }
    }
    
    private func fetchIsVerified(completion: @escaping (Bool?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let ref = Database.database().reference()
        ref.child(userId).child("verified").observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.value as? Bool) // Role is assumed to be stored as a String
        }
    }
    
    func navigateToMain() {
        currentView = .main
    }
        
        func navigateToHealth() {
            currentView = .health
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
    // Add navigation methods for the new cases
    func navigateToHealthModel(healthModel: HealthModel) {
        currentView = .healthModel(healthModel)
    }
    
    func navigateToHealthResources(healthModel: HealthModel) {
        currentView = .healthResources(healthModel)
    }
    func navigateToHealthDetail(mapItem: MKMapItem, healthModel: HealthModel) {
        currentView = .healthDetail(mapItem, healthModel)
    }
    func navigateToProfile() {
        currentView = .profile
    }
}

