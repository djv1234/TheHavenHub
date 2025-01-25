//
//  MedicalServices.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/25/25.
//

import Foundation
import CoreLocation

// Root object for the GeoJSON response
struct MedicalServicesResponse: Codable {
    let features: [MedicalService]
}

// Represents a single medical service
struct MedicalService: Codable, Identifiable {
    let id: Int // Use the "id" field from the JSON
    let geometry: Geometry
    let properties: Properties

    struct Geometry: Codable {
        let coordinates: [Double] // Longitude, Latitude
    }

    struct Properties: Codable {
        let POI_NAME: String
        let POI_TYPE: String
        let PHONE_NUM: String?
    }
} 

