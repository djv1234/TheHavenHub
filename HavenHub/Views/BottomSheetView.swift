//
//  BottomSheetView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/11/25.
//
import SwiftUI
import MapKit

struct BottomSheetView: View {
    // Bindings for dynamic data shared with the parent view or other components
    @Binding var offsetY: CGFloat // Controls the vertical position of the bottom sheet
    @Binding var isKeyboardVisible: Bool // Tracks the keyboard visibility
    @Binding var cameraPosition: MapCameraPosition // Current position of the map camera
    @Binding var showEmergency: Bool // Indicates whether the emergency button/action is shown
    @Binding var mapItems: [MKMapItem] // List of map search results
    @Binding var region: MKCoordinateRegion? // Current map region
    @Binding var currentItem: MKMapItem? // Currently selected map item
    @Binding var showTitle: Bool // Determines whether to display the title in the bottom sheet
    @Binding var showingMenu: Bool

    // State properties for internal view management
    @State var lastDragPosition: CGFloat = 0 // Tracks the last drag position of the bottom sheet
    @State private var searchText: String = "" // Holds the search text entered by the user
    @State var userLocation: MKCoordinateRegion // Tracks the user's current location
    @State private var keyboardHeight: CGFloat = 0 // Stores the keyboard height when visible
    @FocusState private var nameIsFocused: Bool // Tracks whether the search bar is focused
    @Binding var route: MKRoute?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    // Handle Bar at the top of the bottom sheet for drag interaction
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    // Search Bar component
                    SearchBarView(
                        searchText: $searchText,
                        isKeyboardVisible: $isKeyboardVisible,
                        showTitle: $showTitle,
                        offsetY: $offsetY,
                        mapItems: $mapItems,
                        keyboardHeight: $keyboardHeight,
                        region: region, nameIsFocused: $nameIsFocused
                    )

                    // Conditionally display either the search results or the emergency button
                    if isKeyboardVisible {
                        // Search results are shown when the keyboard is visible
                        SearchResultsView(
                            searchText: $searchText,
                            mapItems: $mapItems,
                            currentItem: $currentItem,
                            keyboardHeight: $keyboardHeight, nameIsFocused: $nameIsFocused, route: $route, showingMenu: $showingMenu
                        )
                        .transition(.move(edge: .bottom))
                    } else if showingMenu{
                        
                        MapMenuView(mapItem: $currentItem, showingMenu: $showingMenu)
                            .transition(.move(edge: .bottom))
                            .transition(.opacity)
                        
                    } else {
                        // Emergency button is shown when the keyboard is hidden
                        ButtonView(showEmergency: $showEmergency, geometry: geometry, cameraPosition: $cameraPosition)
                            .transition(.move(edge: .bottom))
                    }

                    Spacer() // Pushes content to the top
                }
                .frame(width: geometry.size.width, height: geometry.size.height + 100) // Sets the bottom sheet size
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub) // Custom background fill
                        .shadow(radius: 10) // Adds shadow for depth
                )
                .offset(y: min(max(offsetY, geometry.size.height * 0.08), geometry.size.height * (4/7))) // Restricts drag range
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Updates offset during drag, within allowed bounds
                            let newOffset = lastDragPosition + value.translation.height
                            if newOffset >= geometry.size.height * 0.08 && newOffset <= geometry.size.height * (4/7) && !isKeyboardVisible {
                                offsetY = newOffset
                            }
                        }
                        .onEnded { _ in
                            // Snaps to either top or bottom position after drag ends
                            let screenHeight = geometry.size.height
                            let middlePoint = screenHeight * 0.4
                            if offsetY < middlePoint {
                                offsetY = screenHeight * 0.08 // Snap to top
                                withAnimation { showTitle = false }
                            } else {
                                offsetY = screenHeight * (4/7) // Snap to bottom
                                withAnimation { showTitle = true }
                            }
                            lastDragPosition = offsetY // Save final position
                        }
                )
                .animation(.easeInOut, value: offsetY) // Smooth animations for offset changes
            }
            .edgesIgnoringSafeArea(.all) // Ensures the bottom sheet overlaps system areas
            .onAppear {
                // Initialize the bottom sheet position on view load
                offsetY = geometry.size.height * (4/7)
            }
        }
        .onReceive(Timer.publish(every: 120, on: .main, in: .common).autoconnect()) { _ in
            // Periodically update the user's location
            let userLocationFunc = UserLocation()
            userLocation = userLocationFunc.getUserLocation()
        }
    }
}
