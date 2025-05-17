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
   @StateObject private var locationManager = LocationManager()
   let locationSearch: UserLocation
   
   var body: some View {
       Button(action: {
           withAnimation {
               if let userLocation = locationManager.userLocation {
                   let newRegion = MKCoordinateRegion(
                       center: userLocation,
                       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                   )
                   cameraPosition = .region(newRegion)
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
       if let location = locations.last {
           userLocation = location.coordinate
           locationManager.stopUpdatingLocation()
       }
   }
}

