//
//  UserLocation.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/16/25.
//


import SwiftUI
import MapKit

struct UserLocation {
    
    @Binding var cameraPosition: MapCameraPosition
    
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
    
    func getUserLocation() -> MKCoordinateRegion{
        if let currentLocation = CLLocationManager().location {
            let coordinate = currentLocation.coordinate
            return MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
        } else {
            print("User location not available")
        
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

            return region
        }
    }

}

