//
//  ViewManager.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import MapKit

class ViewManager: NSObject, ObservableObject {
    @Published var currentView: ViewType
    
    enum ViewType {
        case main
        case profile
        case health
        case healthModel(HealthModel)
        case healthDetail(MKMapItem, HealthModel)
        case healthResources(HealthModel)
        case login
    }
    
    override init() {
            // Initialize stored properties before calling super.init()
                let initialView = Auth.auth().currentUser != nil ? ViewType.main : .login
                self.currentView = initialView
                super.init()
        }
    
    // Simplified navigation methods using a single method with a parameter
    func navigateToMain() {
            currentView = .main
        }
        
        func navigateToProfile() {
            currentView = .profile
        }
        
        func navigateToHealth() {
            currentView = .health
        }
        
        func navigateToLogin() {
            currentView = .login
        }
        
        // Add navigation methods for the new cases
        func navigateToHealthModel(healthModel: HealthModel) {
            currentView = .healthModel(healthModel)
        }
    
        func navigateToHealthDetail(mapItem: MKMapItem, healthModel: HealthModel) {
            currentView = .healthDetail(mapItem, healthModel)
        }
        
        func navigateToHealthResources(healthModel: HealthModel) {
            currentView = .healthResources(healthModel)
        }
}

