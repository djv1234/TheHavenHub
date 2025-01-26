//
//  HealthModel.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//

struct HealthModel: Codable {
    var type: String
    var icon: String
    var color: String
    var info: [Info]
}

struct Info: Codable {
    var title: String
    var text: String
}
