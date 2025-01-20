//
//  Route.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import MapKit
import SwiftUI

struct Route {
    
    func calculateRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completion: @escaping (MKRoute?) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating route: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let route = response?.routes.first {
                completion(route)
            } else {
                completion(nil)
            }
        }
    }
}


