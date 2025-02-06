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
<<<<<<< HEAD:HavenHub/Views/MainView/Map/OverMap/LocationButton.swift
    
    let userLocation: UserLocation
    let routeCalc: RouteCalculator
=======
    @StateObject private var locationManager = LocationManager()
    let locationSearch: UserLocation
>>>>>>> khush:HavenHub/Views/LocationButton.swift
    
    var body: some View {
        Button(action: {
            withAnimation {
<<<<<<< HEAD:HavenHub/Views/MainView/Map/OverMap/LocationButton.swift
                if let route = route {
                    cameraPosition = routeCalc.adjustCameraForRoute(route)
                } else {
                    userLocation.goToUserLocation(cameraPosition: $cameraPosition)
=======
                if let userLocation = locationManager.userLocation {
                    let newRegion = MKCoordinateRegion(
                        center: userLocation,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    cameraPosition = .region(newRegion)
>>>>>>> khush:HavenHub/Views/LocationButton.swift
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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
        }
    }
}
