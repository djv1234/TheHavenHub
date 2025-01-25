//
//  HealthView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 1/24/25.
//

import SwiftUI
import MapKit

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), // Default: Columbus, OH
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var searchQuery = "" // User input for search
    @State private var suggestedServices: [MedicalService] = []

    var body: some View {
        NavigationView {
            VStack {
                // Map with annotations
                Map(
                    coordinateRegion: Binding(
                        get: {
                            if let userLocation = viewModel.userLocation {
                                return MKCoordinateRegion(
                                    center: userLocation,
                                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                )
                            } else {
                                return region // Default region
                            }
                        },
                        set: { region = $0 }
                    )
                ) {_ in 
                    ForEach(viewModel.medicalServices) { service in
                        Annotation(
                            <#LocalizedStringKey#>, coordinate: CLLocationCoordinate2D(
                                latitude: service.geometry.coordinates[1],
                                longitude: service.geometry.coordinates[0]
                            )
                        ) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title)
                                Text(service.properties.POI_NAME)
                                    .font(.caption)
                                    .fixedSize()
                            }
                        }
                    }
                }
                .frame(height: 300)
                .cornerRadius(15)
                .padding()

                // Search bar
                TextField("Search for health facilities...", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: searchQuery) { newValue in
                        filterFacilities()
                    }

                // Suggested services
                if !suggestedServices.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Suggested Nearby Facilities:")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(suggestedServices) { service in
                                    VStack {
                                        Text(service.properties.POI_NAME)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                        Text(service.properties.POI_TYPE)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 5)
                }

                // List of filtered medical services
                List(filteredFacilities()) { service in
                    VStack(alignment: .leading) {
                        Text(service.properties.POI_NAME)
                            .font(.headline)
                        Text(service.properties.POI_TYPE)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        if let phone = service.properties.PHONE_NUM {
                            Text("Phone: \(phone)")
                                .font(.subheadline)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Health Services")
            .onAppear {
                viewModel.fetchMedicalServices()
                generateSuggestions()
            }
        }
    }

    // Filter facilities based on search query
    private func filteredFacilities() -> [MedicalService] {
        if searchQuery.isEmpty {
            return viewModel.medicalServices
        }
        return viewModel.medicalServices.filter {
            $0.properties.POI_NAME.localizedCaseInsensitiveContains(searchQuery) ||
            $0.properties.POI_TYPE.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    // Generate random suggestions near the user
    private func generateSuggestions() {
        guard let userLocation = viewModel.userLocation else { return }
        let nearbyServices = viewModel.medicalServices.filter { service in
            let serviceLocation = CLLocation(
                latitude: service.geometry.coordinates[1],
                longitude: service.geometry.coordinates[0]
            )
            let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            return serviceLocation.distance(from: userLocationCL) < 5000 // Within 5 km
        }
        suggestedServices = Array(nearbyServices.shuffled().prefix(5)) // Pick 5 random services
    }

    // Filter suggestions as search query updates
    private func filterFacilities() {
        if searchQuery.isEmpty {
            generateSuggestions()
        } else {
            suggestedServices = filteredFacilities()
        }
    }
}


#Preview {
    HealthView()
}
