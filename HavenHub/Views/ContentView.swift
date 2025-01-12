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
    var locations: [Location] = Bundle.main.decode("LocationData.json")
    @State private var isKeyboardVisible = false
    @Namespace var mainRegion
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State var visibleRegion: MKCoordinateRegion?
    @State var selectedResult: MKMapItem?
    @State private var shelters: [MKMapItem] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            
            GeometryReader { geometry in
                
                Map(position: $cameraPosition, selection: $selectedResult){
                    
                    ForEach(shelters, id: \.self) {location in
                        Marker(location.name!, coordinate: location.placemark.coordinate)
                            .tint(Color.blue)
                    }
                    
                    UserAnnotation()
                }
                .onMapCameraChange { context in
                    visibleRegion = context.region
                }
                .mapControls {
                    MapCompass()
                        .mapControlVisibility(.hidden)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.495)
                .ignoresSafeArea(.keyboard)
                .safeAreaPadding(.bottom, 50)
            }
            HStack{
                Text("HavenHub")
                    .frame(width: 160, height: 50)
                    .font(.title)
                    .foregroundColor(.primary)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // Safely unwrap the region or use a default fallback
                        if let region = visibleRegion {
                            performSearch(in: region)
                        } else {
                            // Provide a default region if nil
                            let defaultRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: cameraPosition.region?.center.latitude ?? 40.4, longitude: cameraPosition.region?.center.longitude ?? -84.5), // Default to Columbus, Ohio
                                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                            )
                            performSearch(in: defaultRegion)
                        }
                }) {
                    ZStack{
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 40)
                        Image(systemName: "person.circle")
                            .resizable()
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .padding(.horizontal)
            .opacity(showTitle ? 1 : 0)
            
            BottomSheetView(offsetY: $offsetY, showTitle: $showTitle, isKeyboardVisible: $isKeyboardVisible, cameraPosition: $cameraPosition)
        }
        .ignoresSafeArea(.keyboard)
    }

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

    func performSearch(in region: MKCoordinateRegion) {
        
        shelters.removeAll()
        
        let queryKeywords = ["homeless shelter", "food bank", "aid services", "community resources"]
        
        for keyword in queryKeywords {
            findLocations(region: region, searchReq: keyword) { mapItems in
                if let mapItems = mapItems, !mapItems.isEmpty {
                    shelters.append(contentsOf: mapItems)
                }
            }
        }
    }
}

struct BottomSheetView: View {
    @Binding var offsetY: CGFloat // Initial position (halfway up)
    @State var lastDragPosition: CGFloat = 0 // Initial position at the top
    @Binding var showTitle: Bool
    @State private var searchText: String = ""
    @Binding var isKeyboardVisible: Bool
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    // Handle bar
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                    TextField("Search...", text: $searchText)
                        .padding(8)
                        .background(.textFeild)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                            offsetY = geometry.size.height * 0.08
                            isKeyboardVisible = true

                            // Add a slight delay before the animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    showTitle = false
                                }
                            }
                        }

                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                isKeyboardVisible = false
        
                        }
                    
                    
                    HStack {
                        Button(action: { }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green)
                                
                                VStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.main)
                                    Text("Favorites")
                                        .foregroundColor(.main)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        
                        Button(action: { }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red)
                                
                                VStack {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.main)
                                    Text("Emergency")
                                        .foregroundStyle(.main)
                                        .fontWeight(.bold)
                                }
                                
                            }
                        }
                        
                        Button(action: {
                            goToUserLocation()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                                VStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.main)
                                    Text("Location")
                                        .foregroundStyle(.main)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height + 100)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.sub)
                        .shadow(radius: 10)
                )
                .offset(y: min(max(offsetY, geometry.size.height * 0.08), geometry.size.height * (4/7))) // Clamp offset between top and screenHeight * 0.666666
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = lastDragPosition + value.translation.height
                            // Allow dragging only if within the limit
                            if newOffset >= geometry.size.height * 0.08 && newOffset <= geometry.size.height * (4/7) && isKeyboardVisible == false{
                                offsetY = newOffset
                            }
                        }
                        .onEnded { value in
                            let screenHeight = geometry.size.height
                            let middlePoint = screenHeight * 0.4
                            
                            // Snap to closest position
                            if offsetY < middlePoint {
                                offsetY = screenHeight * 0.08 // Snap to top
                                withAnimation {
                                    showTitle = false
                                }
                            } else {
                                offsetY = screenHeight * (4/7) // Snap to bottom
                                withAnimation {
                                    showTitle = true
                                }
                            }
                            lastDragPosition = offsetY
                        }
                )
                .animation(.easeInOut, value: offsetY)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                offsetY = geometry.size.height * (4/7)
            }
        }
    }
    func goToUserLocation() {
        if let currentLocation = CLLocationManager().location {
            let coordinate = currentLocation.coordinate
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        } else {
            print("User location not available")
        }
    }
}
