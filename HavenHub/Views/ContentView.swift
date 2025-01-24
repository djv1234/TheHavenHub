//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var offsetY: CGFloat = 540
    @State var showTitle: Bool = true
    @State private var isKeyboardVisible = false
    @State private var showingMenu = false
    @State var cameraPosition: MapCameraPosition = .automatic
    @State var visibleRegion: MKCoordinateRegion?
    @State private var mapItems: [MKMapItem] = []
    @State private var currentItem: MKMapItem?
    @State var showEmergency: Bool = false
    @State var route: MKRoute?
    
    let locationSearch = UserLocation()
    
    var body: some View {
        ZStack(alignment: .top) {
            MainMapView(cameraPosition: $cameraPosition,
                        route: $route,
                        currentItem: $currentItem,
                        showingMenu: $showingMenu,
                        visibleRegion: $visibleRegion)

            TitleBarView(showTitle: $showTitle, route: $route, cameraPosition: $cameraPosition, locationSearch: locationSearch)

            BottomSheetView(
                offsetY: $offsetY,
                isKeyboardVisible: $isKeyboardVisible,
                cameraPosition: $cameraPosition,
                showEmergency: $showEmergency,
                mapItems: $mapItems,
                region: $visibleRegion,
                currentItem: $currentItem,
                showTitle: $showTitle,
                showingMenu: $showingMenu,
                route: $route,
                userLocation: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )

            EmergencyView(showEmergency: $showEmergency)
                .opacity(showEmergency ? 1 : 0)
        }
        .ignoresSafeArea(.keyboard)
    }
}
