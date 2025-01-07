//
//  TopLevelElement.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/8/25.
//


import Foundation

// MARK: - TopLevelElement
struct TopLevelElement: Codable {
    let title, description: String
    let latitude, longitude: Double
    let type: String
    let capacityStatus: Int?

    enum CodingKeys: String, CodingKey {
        case title, description, latitude, longitude, type
        case capacityStatus = "capacity_status"
    }
}

typealias TopLevel = [TopLevelElement]