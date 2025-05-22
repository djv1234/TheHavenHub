//
//  StreetCard.swift
//  HavenHub
//
//  Created by Dmitry Volf on 5/20/25.
//

import Foundation

struct StreetCard: Codable {
    let type: String
    let name: String
    let latitude: Double?
    let longitude: Double?
    let services: String
    let address: String
    let phone: String
    let hours: String
    let website: String
}
