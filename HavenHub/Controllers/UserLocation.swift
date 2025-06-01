//
//  UserLocation.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/16/25.
//


import SwiftUI
import MapKit
import CoreLocation
import Combine

class UserLocation: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentRegion: MKCoordinateRegion? // Observable region for SwiftUI
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // Request location permission
        locationManager.startUpdatingLocation() // Start updating location
    }
    
    func goToUserLocation(cameraPosition: Binding<MapCameraPosition>) {
        if let region = currentRegion {
            cameraPosition.wrappedValue = .region(region)
        } else {
            print("User location not available, using default region")
            // Fallback to Columbus, Ohio
            cameraPosition.wrappedValue = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            )
        }
    }
    
    func getUserLocation() -> MKCoordinateRegion {
        if let region = currentRegion {
            return region
        } else {
            print("User location not available, returning default region")
            // Fallback to Columbus, Ohio
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // Update currentRegion with the latest location
        currentRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted, .notDetermined:
            // Set default region if location access is unavailable
            currentRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        // Set default region on error
        currentRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}

