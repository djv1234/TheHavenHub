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
    
    let userLocation: UserLocation
    let routeCalc: RouteCalculator
    
    var body: some View {
        Button(action: {
            withAnimation {
                if let route = route {
                    cameraPosition = routeCalc.adjustCameraForRoute(route)
                } else {
                    userLocation.goToUserLocation(cameraPosition: $cameraPosition)
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
}
