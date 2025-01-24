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
    
    let locationSearch = UserLocation()
    
    var body: some View {
        GeometryReader { geometry in
            Map(position: $cameraPosition) {
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

                    if let centerCoordinate = getCenterCoordinate(from: route) {
                        Annotation("", coordinate: centerCoordinate) {
                            
                            
                            SpeechBubble(rectangleWidth: 50)
                                .stroke(Color.teal, lineWidth: 5)
                                .fill(.blue)
                                .frame(width: 100, height: 30)
                                .offset(x: 0, y: -20)
                                .overlay {
                                    Text("5 mins")
                                        .offset(x: 0, y: -25)
                                        .fontWeight(.bold)
                                    
                                }
                        }
                    }
                }
            }
            .onAppear {
                locationSearch.goToUserLocation(cameraPosition: $cameraPosition)
            }
            .onChange(of: route) { _, newValue in
                if let newRoute = newValue {
                    withAnimation {
                        adjustCameraForRoute(newRoute)
                    }
                }
            }
            .onChange(of: showingMenu) { _, newValue in
                if !newValue {
                    route = nil
                    currentItem = nil
                    withAnimation {
                        locationSearch.goToUserLocation(cameraPosition: $cameraPosition)
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

    private func adjustCameraForRoute(_ route: MKRoute) {
        let routeBoundingRect = route.polyline.boundingMapRect
        let centerCoordinate = MKMapPoint(x: routeBoundingRect.midX, y: routeBoundingRect.midY).coordinate
        cameraPosition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: route.distance * 2.5))
    }

    private func getCenterCoordinate(from route: MKRoute) -> CLLocationCoordinate2D? {
        let polyline = route.polyline
        let pointCount = polyline.pointCount
        let points = polyline.points()
        
        guard pointCount > 0 else { return nil }
        
        let middleIndex = pointCount / 2
        return CLLocationCoordinate2D(latitude: points[middleIndex].coordinate.latitude,
                                      longitude: points[middleIndex].coordinate.longitude)
    }
}
