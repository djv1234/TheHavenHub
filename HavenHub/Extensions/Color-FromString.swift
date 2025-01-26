//
//  Color-FromString.swift
//  HavenHub
//
//  Created by Garrett Butchko on 1/26/25.
//
import SwiftUI

extension Color {
    static func fromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "blue": return .blue
        case "purple": return .purple
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "teal": return .teal
        case "gold": return Color("#FFD700")
        case "gray": return .gray
        default: return .primary // Default fallback color
        }
    }
}
