//
//  LocationButton.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/23/25.
//

import SwiftUI
import MapKit

struct LocationButton: View {
    @Binding var route: MKRoute?
    @Binding var cameraPosition: MapCameraPosition
    let locationSearch: UserLocation
    
    var body: some View {
        Button(action: {
            withAnimation {
                if let route = route {
                    adjustCameraForRoute(route)
                } else {
                    locationSearch.goToUserLocation(cameraPosition: $cameraPosition)
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                Image(systemName: "location.fill")
                    .resizable()
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private func adjustCameraForRoute(_ route: MKRoute) {
        let routeBoundingRect = route.polyline.boundingMapRect
        let centerCoordinate = MKMapPoint(x: routeBoundingRect.midX, y: routeBoundingRect.midY).coordinate
        cameraPosition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: route.distance * 2.5))
    }
}
