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
        center: CLLocationCoordinate2D(latitude: 39.9612, longitude: -82.9988), // Columbus, OH
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        NavigationView {
            VStack {
                // Map with annotations for medical services
                Map(coordinateRegion: $region, annotationItems: viewModel.medicalServices) { service in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: service.geometry.coordinates[1], // Latitude
                        longitude: service.geometry.coordinates[0] // Longitude
                    )) {
                        VStack {
                            Image(systemName: "cross.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(service.properties.POI_NAME)
                                .font(.caption)
                                .fixedSize()
                        }
                    }
                }
                .frame(height: 300)
                .cornerRadius(15)
                .padding()

                // List of medical services
                List(viewModel.medicalServices) { service in
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
            }
        }
    }
}


#Preview {
    HealthView()
}
