//
//  ViewManager.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

import SwiftUI

class ViewManager: ObservableObject {
    @Published var currentView: ViewType = .main
    
    enum ViewType {
        case main
        case profile
        case health
    }
    
    func navigateToMain() {
        currentView = .main
    }
    
    func navigateToProfile() {
        currentView = .profile
    }
    
    func navigateToHealth() {
        currentView = .health
    }
}
