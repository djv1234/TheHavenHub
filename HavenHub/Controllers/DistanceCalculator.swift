//
//  DistanceCalc.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/20/25.
//

import CoreLocation

struct DistanceCalculator {

    func distanceInMiles(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        
        let distanceInMeters = location1.distance(from: location2)
        let miles = distanceInMeters * 0.000621371  // Convert meters to miles
        
        return floor(miles * 10) / 10.0
    }
    
    func estimatedTravelTime(from coordinate1: CLLocationCoordinate2D, to coordinate2: CLLocationCoordinate2D) -> String {
        let distanceInMiles = distanceInMiles(coordinate1: coordinate1, coordinate2: coordinate2)
        let estimatedTime = distanceInMiles * 35
        
        let hours = Int(estimatedTime) / 60
        let minutes = Int(estimatedTime) % 60
        
        if hours > 0 && minutes != 0 {
            return "\(hours) hrs \(minutes) mins"
        } else {
            return "\(minutes) mins"
        }
    }
}
