//
//  Route.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import MapKit
import SwiftUI

struct RouteCalculator{
    
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
    
    func adjustCameraForRoute(_ route: MKRoute) -> MapCameraPosition{
        let routeBoundingRect = route.polyline.boundingMapRect
        let centerCoordinate = MKMapPoint(x: routeBoundingRect.midX, y: routeBoundingRect.midY).coordinate
        return .camera(MapCamera(centerCoordinate: centerCoordinate, distance: route.distance * 2.5))
    }
    
    func getCenterCoordinate(from route: MKRoute) -> CLLocationCoordinate2D? {
        let polyline = route.polyline
        let pointCount = polyline.pointCount
        let points = polyline.points()
        
        guard pointCount > 0 else { return nil }
        
        let middleIndex = pointCount / 2
        return CLLocationCoordinate2D(latitude: points[middleIndex].coordinate.latitude,
                                      longitude: points[middleIndex].coordinate.longitude)
    }
}


