//
//  Resource.swift
//  HavenHub
//
//  Created by Dmitry Volf on 5/21/25.
//

import Foundation
import MapKit

   struct Resource: Identifiable {
       let id = UUID()
       let name: String
       let coordinate: CLLocationCoordinate2D?
       let address: String?
       let phone: String?
       let url: URL?
       let services: String?
       let hours: String?
   }

   // Conversion functions
   func resource(from mapItem: MKMapItem) -> Resource {
       return Resource(
           name: mapItem.name ?? "Unnamed",
           coordinate: mapItem.placemark.coordinate,
           address: mapItem.placemark.title,
           phone: mapItem.phoneNumber,
           url: mapItem.url,
           services: nil,
           hours: nil
       )
   }

   func resource(from streetCard: StreetCard) -> Resource {
       let coordinate: CLLocationCoordinate2D?
       if let lat = streetCard.latitude, let lon = streetCard.longitude {
           coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
       } else {
           coordinate = nil
       }
       return Resource(
           name: streetCard.name,
           coordinate: coordinate,
           address: streetCard.address.isEmpty ? nil : streetCard.address,
           phone: streetCard.phone.isEmpty ? nil : streetCard.phone,
           url: streetCard.website.isEmpty ? nil : URL(string: streetCard.website)!,
           services: streetCard.services.isEmpty ? nil : streetCard.services,
           hours: streetCard.hours.isEmpty ? nil : streetCard.hours
       )
   }
