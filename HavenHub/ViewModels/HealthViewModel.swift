//
//  HealthViewModel.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/25/25.
//

import SwiftUI
import Combine

class HealthViewModel: ObservableObject {
    @Published var medicalServices: [MedicalService] = []
    
    func fetchMedicalServices() {
        // Replace with your API endpoint
        let urlString = "https://maps2.columbus.gov/arcgis/rest/services/Schemas/PointsOfInterest/MapServer/5/query?outFields=*&where=1%3D1&f=geojson"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MedicalServicesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.medicalServices = decodedResponse.features
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}
