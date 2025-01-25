//
//  MedicalServices.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/25/25.
//

import Foundation
import CoreLocation

// Model for API data
struct MedicalServicesResponse: Codable {
    let features: [MedicalService]
}

struct MedicalService: Codable, Identifiable {
    let id: Int
    let geometry: Geometry
    let properties: Properties

    struct Geometry: Codable {
        let coordinates: [Double] // Longitude, Latitude
    }

    struct Properties: Codable {
        let POI_NAME: String
        let POI_TYPE: String
        let PHONE_NUM: String?
        let LSN: String
    }
}

