//
//  HealthResourcesDetailView.swift
//  HavenHub
//
//  Created by Dmitry Volf on 3/3/25.
//

import SwiftUI
import MapKit

struct HealthResourcesDetailView: View {
    @StateObject var viewManager: ViewManager
    let resource: MKMapItem
    @State private var cameraPosition: MapCameraPosition?
    @State private var showMapOptions = false
    @State private var description: String = "No description available"
    @State var healthModel: HealthModel

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        viewManager.navigateToHealthResources(healthModel: healthModel)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.accentColor)
                        Text("Back")
                            .foregroundColor(.accentColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                Spacer()
            }

            
            ScrollView {
            Text(resource.name ?? "Unnamed Resource")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            if let position = cameraPosition {
                Map(position: .constant(position)) {
                    Marker(resource.name ?? "Unknown", coordinate: resource.placemark.coordinate)
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            }

            
                VStack(alignment: .leading, spacing: 10) {
                                        if let phone = resource.phoneNumber {
                                            Button(action: {
                                                if let phoneURL = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
                                                    UIApplication.shared.open(phoneURL)
                                                }
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.red)
                                                        .frame(height: 50)
                                                    HStack(spacing: 8) {
                                                        Image(systemName: "phone.fill")
                                                        Text("Call \(phone)")
                                                            .fontWeight(.bold)
                                                    }
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 10)
                                                }
                                            }
                                        }
                                        // Website
                                        if let url = resource.url, !url.absoluteString.contains("mailto:") {
                                            Button(action: {
                                                UIApplication.shared.open(url)
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.red)
                                                        .frame(height: 50)
                                                    HStack(spacing: 8) {
                                                        Image(systemName: "safari.fill")
                                                        Text("Visit \(url.absoluteString)")
                                                            .fontWeight(.bold)
                                                            .lineLimit(nil)
                                                            .truncationMode(.tail)
                                                    }
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 10)
                                                }
                                            }
                                        }

                                        // Address
                                        if let address = resource.placemark.title {
                                            Button(action: {
                                                showMapOptions = true
                                            }) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(Color.accentColor)
                                                        .frame(height: 50)
                                                    HStack(spacing: 8) {
                                                        Image(systemName: "globe.americas.fill")
                                                        Text("Navigate to \(address)")
                                                            .fontWeight(.bold)
                                                            .lineLimit(2)
                                                            .truncationMode(.tail)
                                                    }
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 10)
                                                }
                                            }
                                            .confirmationDialog("Open in ...", isPresented: $showMapOptions, titleVisibility: .visible) {
                                                Button("Open in Apple Maps") {
                                                    if let resourceName = resource.name, let address = resource.placemark.title {
                                                        let query = "\(resourceName), \(address)"
                                                        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                                        let appleMapsURL = URL(string: "http://maps.apple.com/?q=\(encodedQuery)")!
                                                        UIApplication.shared.open(appleMapsURL)
                                                    }
                                                }
                                                Button("Open in Google Maps") {
                                                    if let resourceName = resource.name, let address = resource.placemark.title {
                                                        let query = "\(resourceName), \(address)"
                                                        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                                        let googleMapsURL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)")!
                                                        UIApplication.shared.open(googleMapsURL)
                                                    }
                                                }
                                                Button("Cancel", role: .cancel) { }
                                            }
                                        } 
                                        // Description
                                        Text("Description")
                                            .font(.headline)
                                            .padding(.top, 10)
                                        Text(description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 10)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Resource Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if cameraPosition == nil {
                let coordinate = resource.placemark.coordinate
                cameraPosition = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }

            if let name = resource.name {
                description = "This is \(name). For more information, including how they can help you, please contact them via the provided phone number or website."
            }
        }
    }
}
