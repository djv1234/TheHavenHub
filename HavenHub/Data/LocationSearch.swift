//
//  LocationSearch.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/15/25.
//
import MapKit
import SwiftUI

struct LocationSearch {
    
    @Binding var mapItems: [MKMapItem]
    
    func findLocations(region: MKCoordinateRegion, searchReq: String, completion: @escaping ([MKMapItem]?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchReq
        searchRequest.region = region

        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let error = error {
                print("Error during search: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response else {
                print("No response received.")
                completion(nil)
                return
            }
            
            completion(response.mapItems)
        }
    }
    
    func performSearch(in region: MKCoordinateRegion, words: [String]) {
        
        self.mapItems.removeAll()
        
        let queryKeywords = words
        
        for keyword in queryKeywords {
            findLocations(region: region, searchReq: keyword) { mapItems1 in
                if let mapItems1 = mapItems1, !mapItems1.isEmpty {
                    self.mapItems.append(contentsOf: mapItems1)
                }
            }
        }
    }
    
    
}

