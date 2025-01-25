//
//  HealthViewModel.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/25/25.
//

import SwiftUI
import Combine

import CoreLocation

class HealthViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var medicalServices: [MedicalService] = []
    @Published var userLocation: CLLocationCoordinate2D? // User's current location

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    func fetchMedicalServices() {
        let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        let fileURL = downloadsPath?.appendingPathComponent("Medical_Facilities.geojson")

        guard let url = fileURL else {
            print("Error: Could not locate file in Downloads folder.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedResponse = try JSONDecoder().decode(MedicalServicesResponse.self, from: data)

            DispatchQueue.main.async {
                self.medicalServices = decodedResponse.features
            }
        } catch {
            print("Error decoding JSON from file: \(error)")
        }
    }
}
