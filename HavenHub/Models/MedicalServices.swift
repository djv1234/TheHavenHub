//
//  MedicalServices.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/25/25.
//

import Foundation
import CoreLocation

// Root object for the GeoJSON response
struct MedicalServicesResponse: Codable, Hashable {
    let features: [MedicalService]
}

// Represents a single medical service
struct MedicalService: Codable, Identifiable, Hashable {
    let id: Int // Use the "id" field from the JSON
    let commenSymptoms: [String]
}

