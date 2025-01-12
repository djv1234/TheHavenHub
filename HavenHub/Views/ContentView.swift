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
    @State var showEmergency: Bool = false
    
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
            
            BottomSheetView(offsetY: $offsetY, showTitle: $showTitle, isKeyboardVisible: $isKeyboardVisible, cameraPosition: $cameraPosition, showEmergency: $showEmergency)
            
            
            EmergencyView(showEmergency: $showEmergency)
                .opacity(showEmergency ? 1 : 0)
            
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
