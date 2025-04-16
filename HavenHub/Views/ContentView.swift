//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var viewManager = ViewManager()
    @StateObject var authViewModel = AuthViewModel()
    
    @State private var showBottomSheet: Bool = false
    @State private var showResources: Bool = false
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var resources: [MKMapItem] = []
    
    var body: some View {
        VStack {
            switch viewManager.currentView {
            case .main:
                MainView(viewManager: viewManager, visibleRegion: $visibleRegion)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
            case .health:
                HealthView(viewManager: viewManager)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .healthModel(let healthModel):
                HealthModelView(viewManager: viewManager,
                                showBottomSheet: $showBottomSheet,
                                showResources: $showResources,
                                resources: $resources,
                                healthModel: healthModel)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .healthResources(let healthModel):
                            HealthResourcesView(
                                healthModel: healthModel, cameraPosition: $cameraPosition,
                                visibleRegion: $visibleRegion,
                                resources: $resources,
                                showBottomSheet: $showBottomSheet,
                                showResources: $showResources,
                                showTitle: .constant(false),
                                viewManager: viewManager
                            )
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            case .healthDetail(let mapItem, let healthModel):
                HealthResourcesDetailView(viewManager: viewManager, resource: mapItem, healthModel: healthModel)
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
