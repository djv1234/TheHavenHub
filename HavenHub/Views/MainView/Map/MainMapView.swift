//
//  MainMapView.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI
import MapKit

struct MainMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var route: MKRoute?
    @Binding var currentItem: MKMapItem?
    @Binding var showingMenu: Bool
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var shelters: [MKMapItem]
    @Binding var selectedResult: MKMapItem?
    
    let userLocation: UserLocation
    let distanceCalc: DistanceCalculator
    let routeCalc: RouteCalculator
    
    var body: some View {
        GeometryReader { geometry in
            
            Map(position: $cameraPosition, selection: $selectedResult) {
                ForEach(shelters, id: \.self) { shelter in
                    Marker(shelter.name ?? "Unknown", coordinate: shelter.placemark.coordinate)
                        .tint(Color.red)
                }
                
                if let currentItem = currentItem {
                    Marker(item: currentItem)
                }

                UserAnnotation()

                if let route = route {
                    MapPolyline(route)
                        .stroke(
                            Color.blue,
                            style: StrokeStyle(
                                lineWidth: 7,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )

                    if let centerCoordinate = routeCalc.getCenterCoordinate(from: route) {
                        Annotation("", coordinate: centerCoordinate) {
                            
                            TravelTimeBubble(from: userLocation.getUserLocation().center, to: currentItem!.placemark.coordinate, distanceCalc: distanceCalc)
                            
                        }
                    }
                }
            }
            .onAppear {
                userLocation.goToUserLocation(cameraPosition: $cameraPosition)
            }
            .onChange(of: route) { _, newValue in
                if let newRoute = newValue {
                    withAnimation {
                        cameraPosition = routeCalc.adjustCameraForRoute(newRoute)
                    }
                }
            }
            .onChange(of: showingMenu) { _, newValue in
                if !newValue {
                    route = nil
                    currentItem = nil
                    withAnimation {
                        userLocation.goToUserLocation(cameraPosition: $cameraPosition)
                    }
                }
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
    }
    

    
}


struct TravelTimeBubble: View {
    let from: CLLocationCoordinate2D
    let to: CLLocationCoordinate2D
    let distanceCalc: DistanceCalculator
    
    var body: some View {
        let travelTime = distanceCalc.estimatedTravelTime(from: from, to: to)
        
        SpeechBubble(rectangleWidth: CGFloat((travelTime.count + 1) * 10))
            .stroke(Color.teal, lineWidth: 5)
            .fill(.blue)
            .frame(width: 150, height: 30)
            .offset(x: 0, y: -20)
            .shadow(radius: 5)
            .overlay {
                Text(travelTime)
                    .offset(x: 0, y: -25)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
            }
    }
    
    
}
