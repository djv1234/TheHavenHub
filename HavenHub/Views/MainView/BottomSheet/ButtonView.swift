//
//  ButtonView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/15/25.
//
import SwiftUI
import MapKit

struct ButtonView: View {
    // Bindings for shared states and view properties
    @Binding var showEmergency: Bool // Controls whether the emergency view is shown
    @Binding var showFavorites: Bool // Controls whether the favorites view is shown
    var geometry: GeometryProxy // Provides the size and dimensions of the parent view
    @Binding var cameraPosition: MapCameraPosition // Tracks the current position of the map camera
    @StateObject var viewManager: ViewManager
    @Binding var shelters: [MKMapItem]
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var showBottomSheet: Bool
    @Binding var showFoodBank: Bool
    @Binding var showClothing: Bool
    @Binding var showShelter: Bool
    @State var queryWords: [String] = []
    
    var body: some View {
        VStack {
            // First row of buttons
            HStack {
                // Favorites Button
//                Button(action: {
//                    withAnimation() {
//                        showFavorites = true // Show the emergency screen
//                    }
//                }) {
//                    ZStack {
//                        // Background style
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.green)
//                        
//                        // Icon and label
//                        VStack {
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.main) // Custom main color
//                            Text("Favorites")
//                                .foregroundColor(.main)
//                                .fontWeight(.bold)
//                        }
//                    }
//                }
                
                // Emergency Button
                Button(action: {
                    withAnimation() {
                        showEmergency = true // Show the emergency screen
                    }
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red)
                        
                        // Icon and label
                        VStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.main)
                            Text("Emergency")
                                .foregroundStyle(.main)
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .padding([.horizontal]) // Horizontal padding for the button row
            .frame(width: geometry.size.width, height: geometry.size.height * 0.15) // Row height relative to screen size
            
            // Second row of buttons
            HStack {
                // Food Button
                Button(action: {
                    // Hide the bottom sheet when food banks are shown
                    withAnimation {
                        showBottomSheet = false
                        showFoodBank = true
                        queryWords = ["food banks", "food pantry"]
                        if let region = visibleRegion {
                            performSearch(in: region, queryWords: queryWords)
                        } else {
                            // Fallback region if visibleRegion is nil
                            let defaultRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: cameraPosition.region?.center.latitude ?? 40.4, longitude: cameraPosition.region?.center.longitude ?? -84.5),
                                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                            )
                            performSearch(in: defaultRegion, queryWords: queryWords)
                        }
                    }
                    // Action for the Food button (placeholder)
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main) // Custom main color
                            .shadow(radius: 4) // Shadow for depth
                        Image(systemName: "fork.knife")
                            .foregroundColor(Color.yellow)
                    }
                }
                
                // Shelter Button
                Button(action: {
                    // Action for the Shelter button (placeholder)
                    withAnimation {
                        showBottomSheet = false
                        showShelter = true
                        queryWords = ["homeless shelter for people", "drop-in homeless shelter", "overnight homeless shelter", "men's homeless shelter", "women's homeless shelter", "family shelter"]
                        if let region = visibleRegion {
                            performSearch(in: region, queryWords: queryWords)
                        } else {
                            // Fallback region if visibleRegion is nil
                            let defaultRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: cameraPosition.region?.center.latitude ?? 40.4, longitude: cameraPosition.region?.center.longitude ?? -84.5),
                                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                            )
                            performSearch(in: defaultRegion, queryWords: queryWords)
                        }
                    }
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                            .shadow(radius: 4)
                        Image(systemName: "house.fill")
                            .foregroundColor(Color.brown)
                    }
                }
                
                Button(action: {
                    withAnimation{
                        viewManager.navigateToHealth()
                    }
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                            .shadow(radius: 4)
                        
                        Image(systemName: "cross.fill")
                            .foregroundColor(Color.red)
                    }
                }
                
    
                // Clothing Button
                Button(action: {
                    // Action for the Clothing button (placeholder)
                    withAnimation {
                        showBottomSheet = false
                        showClothing = true
                        queryWords = ["clothing donations", "volunteers of America", "thrift store", "thrift shop"
                                      //, "joseph's coat", "new life community outreach", "christ's cocoons", "united //methodist free store", "st.vincent de paul free store", "jordan's crossing"
                        ]
                        if let region = visibleRegion {
                            performSearch(in: region, queryWords: queryWords)
                        } else {
                            // Fallback region if visibleRegion is nil
                            let defaultRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: cameraPosition.region?.center.latitude ?? 40.4, longitude: cameraPosition.region?.center.longitude ?? -84.5),
                                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                            )
                            performSearch(in: defaultRegion, queryWords: queryWords)
                        }
                    }
                }) {
                    ZStack {
                        // Background style
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.main)
                            .shadow(radius: 4)
                        
                        Image(systemName: "hanger")
                            .foregroundColor(Color.purple)
                    }
                }
            }
            .padding([.horizontal]) // Horizontal padding for the button row
            .frame(width: geometry.size.width, height: geometry.size.height * 0.10) // Row height relative to screen size
            
        }
    }
    
    //in findLocations or performSearch, add in the search terms from the streetcard
    func findLocations(region: MKCoordinateRegion, searchReq: String, completion: @escaping ([MKMapItem]?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchReq
        searchRequest.region = region

        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let error = error {
                print("Error during search: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response else {
                print("No response received.")
                completion(nil)
                return
            }
            
            completion(response.mapItems)
        }
    }

    func performSearch(in region: MKCoordinateRegion, queryWords: [String]) {
        // if MKCoordinateRegion.longitude < columbus city limit west, MKCoordinateRegion.longitude > columbus city limit east && MKCoordinateRegion.latitude < columbus city limit north, MKCoordinateRegion.longitude > columbus city limit south { add the street card places to queryWords}
        shelters.removeAll()
        for keyword in queryWords {
            findLocations(region: region, searchReq: keyword) { mapItems in
                if let mapItems = mapItems, !mapItems.isEmpty {
                    shelters.append(contentsOf: mapItems)
                }
            }
        }
    }
    
    func zoomMap(byFactor delta: Double) {
        guard let region = visibleRegion else { return }
        
        let newSpan = MKCoordinateSpan(
            latitudeDelta: region.span.latitudeDelta * delta,
            longitudeDelta: region.span.longitudeDelta * delta
        )
        
        let newRegion = MKCoordinateRegion(
            center: region.center,
            span: newSpan
        )
        
        cameraPosition = .region(newRegion)
    }
}
