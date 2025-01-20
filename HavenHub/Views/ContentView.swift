//
//  ContentView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/7/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    // State variables to manage the UI and functionality
    @State var offsetY: CGFloat = 540 // Initial offset for the bottom sheet
    @State var showTitle: Bool = true // Controls the visibility of the title
    @State private var isKeyboardVisible = false // Tracks the keyboard visibility
    @State private var showingMenu = false // Tracks the keyboard visibility
    @State var cameraPosition: MapCameraPosition = .automatic // Manages the map's camera position
    @State var visibleRegion: MKCoordinateRegion? // Represents the currently visible region on the map
    @State private var mapItems: [MKMapItem] = [] // Stores search results for map items
    @State private var currentItem: MKMapItem? // The currently selected map item
    @State var showEmergency: Bool = false // Controls the visibility of the emergency view
    @State var route: MKRoute?
    let locationSearch = UserLocation()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Main map view
            GeometryReader { geometry in
                Map(position: $cameraPosition) {
                    // Add a marker for the current item if one exists
                    if currentItem != nil {
                        Marker(item: currentItem!)
                    }
                    
                    // User's location annotation
                    UserAnnotation()
                    
                    if let route = route{
                        MapPolyline(route)
                            .stroke(
                                Color.blue,
                                style: StrokeStyle(
                                    lineWidth: 7,
                                    lineCap: .round,
                                    lineJoin: .round, // Optional: Makes line joins rounded too
                                    miterLimit: 0
                                )
                            )

                    }
                }
                .onAppear {
                    locationSearch.goToUserLocation(cameraPosition: $cameraPosition)
                }
                .onChange(of: route, { oldValue, newValue in
                    adjustCameraForRoute(route!)
                })
                .onMapCameraChange { context in
                    // Update the visible region when the map camera changes
                    visibleRegion = context.region
                }
                .mapControls {
                    // Customize the map's compass visibility
                    MapCompass()
                        .mapControlVisibility(.hidden)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.495) // Map height is half the screen
                .ignoresSafeArea(.keyboard) // Ignore safe area adjustments for the keyboard
                .safeAreaPadding(.bottom, 50) // Add padding at the bottom for the map
            }
            
            // Top title bar
            HStack {
                Text("HavenHub") // App title
                    .frame(width: 160, height: 50)
                    .font(.title)
                    .foregroundColor(.primary)
                    .background(.ultraThinMaterial) // Translucent background
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))) // Rounded corners
                    .fontWeight(.bold)
                
                Spacer() // Spacer to push the button to the right
                
                // Location Button
                Button(action: {
                    
                    if let route = route {
                        adjustCameraForRoute(route)
                    } else {
                        locationSearch.goToUserLocation(cameraPosition: $cameraPosition)
                    }
                    
                    // Action for the profile button (placeholder)
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial) // Translucent circular background
                            .frame(width: 40, height: 40)
                        Image(systemName: "location.fill") // Profile icon
                            .resizable()
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                    }
                }
                
                
                // Profile button
                Button(action: {
                    // Action for the profile button (placeholder)
                }) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial) // Translucent circular background
                            .frame(width: 40, height: 40)
                        Image(systemName: "person.fill") // Profile icon
                            .resizable()
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.horizontal) // Horizontal padding for the title bar
            .opacity(showTitle ? 1 : 0) // Hide or show the title bar based on `showTitle`
            
            // Bottom sheet
            BottomSheetView(
                offsetY: $offsetY,
                isKeyboardVisible: $isKeyboardVisible,
                cameraPosition: $cameraPosition,
                showEmergency: $showEmergency,
                mapItems: $mapItems,
                region: $visibleRegion,
                currentItem: $currentItem,
                showTitle: $showTitle, showingMenu: $showingMenu,
                userLocation: MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), // Default location: Columbus, Ohio
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ), route: $route
            )
            
            // Emergency view overlay
            EmergencyView(showEmergency: $showEmergency)
                .opacity(showEmergency ? 1 : 0) // Show or hide based on `showEmergency`
        }
        .ignoresSafeArea(.keyboard) // Ignore safe area for keyboard visibility adjustments
    }
    
    private func adjustCameraForRoute(_ route: MKRoute) {
        // Calculate the bounding map rect of the polyline
        let routeBoundingRect = route.polyline.boundingMapRect
        
        // Convert the midpoint of the bounding rect to a CLLocationCoordinate2D
        let centerCoordinate = MKMapPoint(x: routeBoundingRect.midX, y: routeBoundingRect.midY).coordinate
        
        // Update the camera position to focus on the polyline
        cameraPosition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: route.distance * 2.5))
    }
}
